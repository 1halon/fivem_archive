import PocketBase from "pocketbase/cjs";
import Config from "../shared/config";

const pocketbase = new PocketBase(
  Config.pocketbase.baseUrl,
  Config.pocketbase.authStore as any,
  Config.pocketbase.lang
);

pocketbase.afterSend = Config.pocketbase.afterSend;
pocketbase.autoCancellation(Config.pocketbase.autoCancellation);
pocketbase.beforeSend = Config.pocketbase.beforeSend;

export default pocketbase;
