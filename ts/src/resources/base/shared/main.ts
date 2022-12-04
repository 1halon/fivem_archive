export function CWait(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
