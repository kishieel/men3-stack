import { PrismaService } from '@app/prisma/prisma.service';
import { UsersService } from '@app/users/users.service';
import { NotFoundException } from '@nestjs/common';
import { Test } from '@nestjs/testing';

describe(UsersService.name, () => {
    let service: UsersService;

    beforeEach(async () => {
        const module = await Test.createTestingModule({
            providers: [{ provide: PrismaService, useValue: dbMock }, UsersService],
        }).compile();
        service = module.get(UsersService);
    });

    afterEach(() => {
        jest.clearAllMocks();
        jest.resetAllMocks();
    });

    it('should return collection of users', async () => {
        dbMock.user.findMany.mockResolvedValue(dbMock.users);

        const result = await service.getUsers();
        expect(result).toEqual({
            data: dbMock.users.map((user) => ({
                id: user.id,
                username: user.username,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt,
            })),
        });
        expect(dbMock.user.findMany).toBeCalledTimes(1);
    });

    it('should return user by id', async () => {
        dbMock.user.findUnique.mockResolvedValue(dbMock.users[0]);

        const result = await service.getUserById('1');
        expect(result).toEqual({
            id: dbMock.users[0].id,
            username: dbMock.users[0].username,
            createdAt: dbMock.users[0].createdAt,
            updatedAt: dbMock.users[0].updatedAt,
        });
        expect(dbMock.user.findUnique).toBeCalledTimes(1);
        expect(dbMock.user.findUnique).toBeCalledWith({ where: { id: '1' } });
    });

    it('should throw not found error when user not exists', async () => {
        dbMock.user.findUnique.mockResolvedValue(null);

        await expect(service.getUserById('3')).rejects.toThrowError(NotFoundException);
        expect(dbMock.user.findUnique).toBeCalledTimes(1);
        expect(dbMock.user.findUnique).toBeCalledWith({ where: { id: '3' } });
    });

    it('should create new user', async () => {
        dbMock.user.findUnique.mockResolvedValue(null);
        dbMock.user.create.mockResolvedValue(dbMock.users[0]);

        const result = await service.createUser({ username: 'user1', password: 'password' });
        expect(result).toEqual({
            id: dbMock.users[0].id,
            username: dbMock.users[0].username,
            createdAt: dbMock.users[0].createdAt,
            updatedAt: dbMock.users[0].updatedAt,
        });
        expect(dbMock.user.findUnique).toBeCalledTimes(1);
        expect(dbMock.user.findUnique).toBeCalledWith({ where: { username: 'user1' } });
        expect(dbMock.user.create).toBeCalledTimes(1);
        expect(dbMock.user.create).toBeCalledWith({ data: { username: 'user1', password: 'password' } });
    });

    it('should throw bad request error when username already exists', async () => {
        dbMock.user.findUnique.mockResolvedValue(dbMock.users[0]);

        await expect(service.createUser({ username: 'user1', password: 'password' })).rejects.toThrowError();
        expect(dbMock.user.findUnique).toBeCalledTimes(1);
        expect(dbMock.user.findUnique).toBeCalledWith({ where: { username: 'user1' } });
        expect(dbMock.user.create).not.toBeCalled();
    });
});

const dbMock = {
    users: [
        { id: '1', username: 'user1', password: 'password', createdAt: new Date(), updatedAt: new Date() },
        { id: '2', username: 'user2', password: 'password', createdAt: new Date(), updatedAt: new Date() },
    ],
    user: {
        findMany: jest.fn(),
        findUnique: jest.fn(),
        create: jest.fn(),
    },
};
