import { Module } from '@nestjs/common';
import { ConfigModule } from '@app/config/config.module';
import { PrismaModule } from '@app/prisma/prisma.module';
import { UsersModule } from '@app/users/users.module';
import { HealthModule } from '@app/health/health.module';

@Module({
    imports: [ConfigModule, HealthModule, PrismaModule, UsersModule],
})
export class AppModule {}
