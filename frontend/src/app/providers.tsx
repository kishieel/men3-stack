import { PropsWithChildren } from 'react';
import { DEFAULT_THEME } from '@app/consts/environment';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ThemeProvider } from 'next-themes';

export default function Providers({ children }: PropsWithChildren) {
    const queryClient = new QueryClient();

    return (
        <QueryClientProvider client={queryClient}>
            <ThemeProvider attribute="class" defaultTheme={DEFAULT_THEME}>
                {children}
            </ThemeProvider>
        </QueryClientProvider>
    );
}
