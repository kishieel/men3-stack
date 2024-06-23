const getenv = <T extends boolean>(name: string, required?: T): T extends true ? string : string | undefined => {
    const value = process.env[name];

    if (!value && required) {
        throw `Missing required environment variable: ${name}`;
    }

    return value as T extends true ? string : string | undefined;
};

export const API_URL = getenv('NEXT_PRIVATE_API_URL', true);
export const DEFAULT_THEME = getenv('NEXT_PRIVATE_DEFAULT_THEME') || 'dark';
