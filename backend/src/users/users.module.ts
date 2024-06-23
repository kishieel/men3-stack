import { UsersController } from '@app/users/users.controller';
import { UsersService } from '@app/users/users.service';
import { Module } from '@nestjs/common';

@Module({
    controllers: [UsersController],
    providers: [UsersService],
})
export class UsersModule {}
