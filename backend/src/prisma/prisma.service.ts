import { Inject, Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaConfig, PrismaConfigKey } from '@app/config/prisma.config';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
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
        await this.$connect();
    }

    async onModuleDestroy() {
        await this.$disconnect();
    }
}
