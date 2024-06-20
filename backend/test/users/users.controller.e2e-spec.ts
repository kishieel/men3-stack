import { UsersController } from '@app/users/users.controller';
import { Test } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { PrismaModule } from '@app/prisma/prisma.module';
import { PrismaService } from '@app/prisma/prisma.service';
import { UsersModule } from '@app/users/users.module';
import { ConfigModule } from '@app/config/config.module';
import * as request from 'supertest';
import { CreateUserRequest } from '@app/users/users.requests';

describe(UsersController.name, () => {
    let app: INestApplication;
    let db: PrismaService;

    beforeEach(async () => {
        const module = await Test.createTestingModule({
            imports: [ConfigModule, PrismaModule, UsersModule],
        }).compile();

        app = module.createNestApplication();
        app.enableShutdownHooks();
        await app.init();

        db = module.get(PrismaService);
    });

    afterAll(async () => {
        await app.close();
    });

    afterEach(async () => {
        jest.clearAllMocks();
        jest.resetAllMocks();
    });

    it('should return collection of users', async () => {
        const users = await Promise.all([
            db.user.create({ data: { username: 'username1', password: 'Password123#' } }),
            db.user.create({ data: { username: 'username2', password: 'Password123#' } }),
        ]);

        request(app.getHttpServer())
            .get('/api/users')
            .expect(200)
            .expect({
                data: users.map((user) => ({
                    id: user.id,
                    username: user.username,
                    createdAt: user.createdAt.toISOString(),
                    updatedAt: user.updatedAt.toISOString(),
                })),
            });
    });

    it('should return user by id', async () => {
        const user = await db.user.create({ data: { username: 'username', password: 'Password123#' } });

        request(app.getHttpServer())
            .get(`/api/users/${user.id}`)
            .expect(200)
            .expect({
                data: {
                    id: user.id,
                    username: user.username,
                    createdAt: user.createdAt.toISOString(),
                    updatedAt: user.updatedAt.toISOString(),
                },
            });
    });

    it('should create user', async () => {
        const data: CreateUserRequest = {
            username: 'username',
            password: 'Password123#',
        };

        request(app.getHttpServer())
            .post('/api/users')
            .send(data)
            .expect(201)
            .expect({
                data: {
                    id: expect.any(String),
                    username: data.username,
                    createdAt: expect.any(String),
                    updatedAt: expect.any(String),
                },
            });

        const count = await db.user.count({ where: { username: data.username } });
        expect(count).toBe(1);
    });
});
