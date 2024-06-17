import { Module } from '@nestjs/common';
import { UsersController } from '@app/users/users.controller';
import { UsersService } from '@app/users/users.service';

@Module({
    controllers: [UsersController],
    providers: [UsersService],
})
export class UsersModule {}
