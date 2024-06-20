import { Inject, Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaConfig, PrismaConfigKey } from '@app/config/prisma.config';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
    private readonly logger = new Logger(PrismaService.name);

    constructor(
        @Inject(PrismaConfigKey)
        private readonly prismaConfig: PrismaConfig,
    ) {
        super({
            datasourceUrl: prismaConfig.url,
            log: prismaConfig.debug ? ['info', 'query', 'warn', 'error'] : undefined,
        });
    }

    async onModuleInit() {
        this.logger.log('Connecting prisma...');
        await this.$connect();
    }

    async onModuleDestroy() {
        this.logger.log('Disconnecting prisma...');
        await this.$disconnect();
    }
}
