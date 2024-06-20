import { ConfigModule } from '@app/config/config.module';
import { HealthModule } from '@app/health/health.module';
import { PrismaModule } from '@app/prisma/prisma.module';
import { UsersModule } from '@app/users/users.module';
import { Module } from '@nestjs/common';

@Module({
    imports: [ConfigModule, HealthModule, PrismaModule, UsersModule],
})
export class AppModule {}
