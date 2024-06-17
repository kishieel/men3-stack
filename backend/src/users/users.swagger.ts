import { ApiOptions } from 'nestjs-swagger-api-spec';
import { UserResource, UsersCollection } from '@app/users/users.resources';
import { ExceptionResource } from '@app/utils/common.resources';

export const UsersSwagger = {
    Controller: {
        apiTagsOptions: (t) => t('Users'),
    },
    GetUsers: {
        apiOperationOptions: (t) =>
            t({
                summary: 'Get all users',
                description: 'Returns a list of all users',
            }),
        apiOkResponseOptions: (t) =>
            t({
                description: 'List of users',
                type: UsersCollection,
            }),
        apiInternalServerErrorResponseOptions: (t) =>
            t({
                description: 'Internal server error',
            }),
    },
    GetUserById: {
        apiOperationOptions: (t) =>
            t({
                summary: 'Get user by ID',
                description: 'Returns a user by ID',
            }),
        apiOkResponseOptions: (t) =>
            t({
                description: 'User',
                type: UserResource,
            }),
        apiNotFoundResponseOptions: (t) =>
            t({
                description: 'User not found',
                type: ExceptionResource,
            }),
        apiInternalServerErrorResponseOptions: (t) =>
            t({
                description: 'Internal server error',
            }),
    },
    CreateUser: {
        apiOperationOptions: (t) =>
            t({
                summary: 'Create user',
                description: 'Creates a new user',
            }),
        apiOkResponseOptions: (t) =>
            t({
                description: 'User',
                type: UserResource,
            }),
        apiBadRequestResponseOptions: (t) =>
            t({
                description: 'Username already exists',
                type: ExceptionResource,
            }),
        apiInternalServerErrorResponseOptions: (t) =>
            t({
                description: 'Internal server error',
            }),
    },
} satisfies Record<string, ApiOptions>;
