export const Delay = (ms: number = 0) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms));

declare global {
  function Delay(ms?: number): Promise<void>;
}
