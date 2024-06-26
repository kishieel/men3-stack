import { PrismaService } from '@app/prisma/prisma.service';
import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { HealthCheck, HealthCheckService, PrismaHealthIndicator } from '@nestjs/terminus';

@Controller('health')
@ApiTags('Health')
export class HealthController {
    constructor(
        private readonly health: HealthCheckService,
        private readonly prisma: PrismaHealthIndicator,
        private readonly db: PrismaService,
    ) {}

    @Get('/liveness')
    @HealthCheck()
    checkLiveness() {
        return this.health.check([() => ({ service: { status: 'up' } })]);
    }

    @Get('/readiness')
    @HealthCheck()
    checkReadiness() {
        return this.health.check([
            () => ({ service: { status: 'up' } }),
            () => this.prisma.pingCheck('prisma', this.db),
        ]);
    }
}
