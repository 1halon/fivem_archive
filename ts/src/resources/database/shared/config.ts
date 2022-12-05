//@ts-ignore
import { BaseAuthStore } from "pocketbase/cjs";

class CustomAuthStore extends BaseAuthStore {}

export default {
  pocketbase: {
    baseUrl: "http://127.0.0.1:8090",
    authStore: new CustomAuthStore(),
    lang: "en-US",
    afterSend: function (response: Response, data: any) {},
    autoCancellation: true,
    beforeSend: function (
      url: string,
      reqConfig: {
        [key: string]: any;
      }
    ) {
      return {};
    },
  },
};
