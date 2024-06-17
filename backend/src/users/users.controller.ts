import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { UsersService } from '@app/users/users.service';
import { ApiSpecification } from 'nestjs-swagger-api-spec';
import { UsersSwagger } from '@app/users/users.swagger';
import { UserResource, UsersCollection } from '@app/users/users.resources';
import { CreateUserRequest } from '@app/users/users.requests';

@Controller('users')
@ApiSpecification(UsersSwagger.Controller)
export class UsersController {
    constructor(private readonly usersService: UsersService) {}

    @Get()
    @ApiSpecification(UsersSwagger.GetUsers)
    async getUsers(): Promise<UsersCollection> {
        return this.usersService.getUsers();
    }

    @Get(':id')
    @ApiSpecification(UsersSwagger.GetUserById)
    async getUserById(@Param('id') id: string): Promise<UserResource> {
        return this.usersService.getUserById(id);
    }

    @Post()
    @ApiSpecification(UsersSwagger.CreateUser)
    async createUser(@Body() request: CreateUserRequest): Promise<UserResource> {
        return this.usersService.createUser(request);
    }
}
