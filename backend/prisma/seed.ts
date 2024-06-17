import { PrismaClient } from '@prisma/client';

const db = new PrismaClient({
    datasourceUrl: process.env.DATABASE_URL,
});

async function bootstrap() {
    // The hashed value is 'password'
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
}

bootstrap()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => await db.$disconnect());
