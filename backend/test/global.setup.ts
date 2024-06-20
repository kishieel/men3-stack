import { PrismaClient } from '@prisma/client';
import { execSync } from 'child_process';
import * as process from 'process';

const DATABASE_URL = 'mysql://root:root@localhost:3306/testing';

export default async () => {
    process.env.DATABASE_URL = DATABASE_URL;

    execSync(`DATABASE_URL="${DATABASE_URL}" yarn prisma:reset`);
    execSync(`DATABASE_URL="${DATABASE_URL}" yarn prisma:deploy`);
};
