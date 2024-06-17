export const throwIf = (condition: boolean, error: Error) => {
    if (condition) {
        throw error;
    }
};
