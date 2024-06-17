import { ApiProperty } from '@nestjs/swagger';

export class ExceptionResource {
    @ApiProperty({ example: 404 })
    statusCode: number;

    @ApiProperty({ example: 'Not Found' })
    error: string;

    @ApiProperty({ example: 'User not found', nullable: true })
    message?: string;
}
