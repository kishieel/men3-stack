import { ConfigType, registerAs } from '@nestjs/config';

export const NestConfigToken = 'NEST_CONFIG';

export const nestConfig = registerAs(NestConfigToken, () => ({
    nodeEnv: process.env.NODE_ENV,
    host: process.env.HOST,
    port: +process.env.PORT,
}));

export const NestConfigKey = nestConfig.KEY;
export type NestConfig = ConfigType<typeof nestConfig>;
