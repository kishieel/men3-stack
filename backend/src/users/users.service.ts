import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '@app/prisma/prisma.service';
import { UserResource, UsersCollection } from '@app/users/users.resources';
import { throwIf } from '@app/utils/throw-if.function';
import { CreateUserRequest } from '@app/users/users.requests';

@Injectable()
export class UsersService {
    constructor(private readonly db: PrismaService) {}

    async getUsers(): Promise<UsersCollection> {
        const users = await this.db.user.findMany();
        const data = users.map((user) => ({
            id: user.id,
            username: user.username,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
        }));

        return { data };
    }

    async getUserById(id: string): Promise<UserResource> {
        const user = await this.db.user.findUnique({ where: { id } });
        throwIf(!user, new NotFoundException('User not found'));

        return {
            id: user.id,
            username: user.username,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
        };
    }

    async createUser(request: CreateUserRequest): Promise<UserResource> {
        const check = await this.db.user.findUnique({ where: { username: request.username } });
        throwIf(!!check, new BadRequestException('Username already exists'));

        const user = await this.db.user.create({
            data: {
                username: request.username,
                password: request.password, // TODO: hash password
            },
        });

        return {
            id: user.id,
            username: user.username,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
        };
    }
}
