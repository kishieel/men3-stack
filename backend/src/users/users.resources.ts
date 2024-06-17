import { ApiProperty } from '@nestjs/swagger';

export class UserResource {
    @ApiProperty({ example: 'clxjgse7g00000cl3hqald3sx' })
    id: string;

    @ApiProperty({ example: 'john.doe@example.com' })
    username: string;

    @ApiProperty({ example: '2021-08-01T00:00:00.000Z' })
    createdAt: Date;

    @ApiProperty({ example: '2021-08-01T00:00:00.000Z' })
    updatedAt: Date;
}

export class UsersCollection {
    @ApiProperty({ type: UserResource, isArray: true })
    data: UserResource[];
}
