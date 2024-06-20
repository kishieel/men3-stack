import { nestConfig } from '@app/config/nest.config';
import { prismaConfig } from '@app/config/prisma.config';
import { Module } from '@nestjs/common';
import { ConfigModule as BaseConfigModule } from '@nestjs/config';
import * as Joi from 'joi';

@Module({
    imports: [
        BaseConfigModule.forRoot({
            isGlobal: true,
            cache: true,
            load: [nestConfig, prismaConfig],
            validationSchema: Joi.object({
                NODE_ENV: Joi.string().valid('development', 'test', 'production').default('production'),
                HOST: Joi.string().default('0.0.0.0'),
                PORT: Joi.number().default(3000),
                DATABASE_URL: Joi.string().required(),
            }),
        }),
    ],
})
export class ConfigModule {}
