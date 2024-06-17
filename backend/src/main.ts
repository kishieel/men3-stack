import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { HttpStatus, ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import { NestConfig, NestConfigToken } from '@app/config/nest.config';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);

    app.getHttpAdapter().getInstance().disable('x-powered-by');

    app.enableCors({
        origin: '*',
        methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
        preflightContinue: false,
        optionsSuccessStatus: 204,
    });

    app.setGlobalPrefix('/api');
    app.useGlobalPipes(
        new ValidationPipe({
            transform: true,
            errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
            forbidUnknownValues: true,
        }),
    );

    const config = new DocumentBuilder()
        .setTitle('API')
        .setDescription('The API description')
        .setVersion('1.0')
        .build();

    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('/api', app, document);

    const configService = app.get(ConfigService);
    const nestConfig = configService.getOrThrow<NestConfig>(NestConfigToken);

    app.enableShutdownHooks();
    await app.listen(nestConfig.port, nestConfig.host);
}

bootstrap().catch(console.error);
