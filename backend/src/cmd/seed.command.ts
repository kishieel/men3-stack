import { AppModule } from '@app/app.module';
import { PrismaService } from '@app/prisma/prisma.service';
import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

async function bootstrap() {
    const logger = new Logger('SeedCommand');
    logger.log('Seeding database...');

    const app = await NestFactory.createApplicationContext(AppModule);
    const db = app.get(PrismaService);

    // plaintext: password
    const password = '$argon2i$v=19$m=16,t=2,p=1$WEF0ZUxiSU9aNHhxcXFkeTRGMnVveWNyZ0llWUsxNzc$l9jHUVTH3p2G3hNBN6I5dQ';

    await db.user.createMany({
        data: [
            { username: 'john.doe@example.com', password },
            { username: 'jane.doe@example.com', password },
            { username: 'john.smith@example.com', password },
            { username: 'jane.smith@example.com', password },
        ],
        skipDuplicates: true,
    });

    await app.close();
    logger.log('Database seeded');
}

bootstrap().catch(console.error);
