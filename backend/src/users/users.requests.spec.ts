import { CreateUserRequest } from '@app/users/users.requests';
import { plainToClass } from 'class-transformer';
import { validateOrReject } from 'class-validator';

describe(CreateUserRequest.name, () => {
    it('should pass validation', async () => {
        const request = plainToClass(CreateUserRequest, {
            username: 'username',
            password: 'Password123#',
        });

        await expect(validateOrReject(request)).resolves.toBeUndefined();
    });

    it('should fail validation when username is not a string', async () => {
        const request = plainToClass(CreateUserRequest, {
            username: 123,
            password: 'Password123#',
        });

        await expect(validateOrReject(request)).rejects.toMatchObject([
            { constraints: { isString: 'username must be a string' } },
        ]);
    });

    it('should fail validation when password is not a string', async () => {
        const request = plainToClass(CreateUserRequest, {
            username: 'username',
            password: 123,
        });

        await expect(validateOrReject(request)).rejects.toMatchObject([
            { constraints: { isString: 'password must be a string' } },
        ]);
    });

    it('should fail validation when password is too weak', async () => {
        const request = plainToClass(CreateUserRequest, {
            username: 'username',
            password: 'password',
        });

        await expect(validateOrReject(request)).rejects.toMatchObject([
            { constraints: { isStrongPassword: 'password is not strong enough' } },
        ]);
    });
});
