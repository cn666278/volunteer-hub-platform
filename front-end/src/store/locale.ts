import { defineStore } from "pinia";

export default defineStore("locale", {
  state: () => ({
    locale: "en",
  }),
  actions: {
    setLocale(locale: string) {
      this.locale = locale;
    },
  },
  // data persistence
  persist: true // default: localStorage (permanent storage in the browser, not cleared when the browser is closed)
});