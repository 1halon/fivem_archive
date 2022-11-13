require("../shared/controls");

const functions = {
  ID(id: number) {},
  KEY(key: string) {},
  NAME(name: string) {},
};

function GetControl(by: keyof typeof functions, control: string | number) {
  const func: any = functions[by];
  if (typeof func === "function") func(control);
}
