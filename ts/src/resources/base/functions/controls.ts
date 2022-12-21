import Controls from "@base/shared/controls";
import type { Control } from "@base/shared/controls";

const kn = (key: string, value: string) =>
    Controls.find((control: Control) => control[key] === value),
  functions = {
    ID: (id: number) => Controls[id],
    KEY: (key: string) => Controls.find((control) => control.key === key),
    NAME: (name: string) => Controls.find((control) => control.name === name),
  };

export function GetControl(
  by: keyof typeof functions,
  control: string | number
) {
  const func: any = functions[by];
  if (typeof func === "function") func(control);
}
