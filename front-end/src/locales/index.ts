import { App } from 'vue'
import { createI18n } from 'vue-i18n'
import { zh } from './zh'
import { en } from './en'
import { cy } from './cy'
console.log(zh)
console.log(en)

const isBrowser = typeof window !== 'undefined' && typeof navigator !== 'undefined';
const language = isBrowser ? (navigator.language || 'en').toLocaleLowerCase() : 'en'; // 获取浏览器的语言设置
const locale = isBrowser ? (localStorage.getItem('lang') || language) : 'en';

const i18n = createI18n({
  legacy: false,
  locale: locale, // 优先从本地存储获取语言设置，如果没有则使用浏览器默认语言
  fallbackLocale: 'en', // 当前语言无法找到匹配的翻译时，使用的备选语言
  messages: {
    en,
    zh,
    cy
  }
})

export const initI18n = (app: App<Element>) => {
  app.use(i18n)
}
