///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП".
// ОбщийМодуль.СистемаБыстрыхПлатежейКлиентСервер.
//
// Клиент-серверные процедуры общих настроек и статических идентификаторов:
//  - получение статусов прикладных операций оплат.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СтатусыОпераций

// Возвращает статус операции "Выполнена".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииВыполнена() Экспорт
	
	Возврат "Выполнена";
	
КонецФункции

// Возвращает статус операции "Выполняется".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииВыполняется() Экспорт
	
	Возврат "Выполняется";
	
КонецФункции

// Возвращает статус операции "Отменена".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииОтменена() Экспорт
	
	Возврат "Отменена";
	
КонецФункции

// Возвращает статус операции "Ошибка".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииОшибка() Экспорт
	
	Возврат "Ошибка";
	
КонецФункции

// Возвращает статус операции "ТребуетсяПодтверждение".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииТребуетсяПодтверждение() Экспорт
	
	Возврат "ТребуетсяПодтверждение";
	
КонецФункции

// Возвращает статус операции "Отклонена".
//
// Возвращаемое значение:
//  Строка - код состояния.
//
Функция СтатусОперацииОтклонена() Экспорт
	
	Возврат "Отклонена";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет проверку наличия запрещенных символов в строке назначения платежа.
//
// Параметры:
//  НазначенияПлатежа - Строка - строка для проверки.
//
// Возвращаемое значение:
// Массив из Строка - запрещенные символы найденные в строке.
//
Функция ЗапрещенныеСимволыНазначенияПлатежа(НазначенияПлатежа) Экспорт
	
	ЗапрещенныеСимволы = Новый Массив;
	Сч = 0;
	Если Не ЗначениеЗаполнено(НазначенияПлатежа) Тогда
		Возврат ЗапрещенныеСимволы;
	КонецЕсли;
	
	Пока Сч <= СтрДлина(НазначенияПлатежа) Цикл
		
		ТекущийСимвол = Сред(НазначенияПлатежа, Сч, 1);
		КодТекущегоСимвола = КодСимвола(ТекущийСимвол);
		СимволРазрешен = ((КодТекущегоСимвола > 65 И КодТекущегоСимвола < 90)
			Или (КодТекущегоСимвола >= 97 И КодТекущегоСимвола <= 122)
			Или (КодТекущегоСимвола >= 1040 И КодТекущегоСимвола <= 1103)
			Или (КодТекущегоСимвола >= 48 И КодТекущегоСимвола <= 57)
			Или (КодТекущегоСимвола >= 32 И КодТекущегоСимвола <= 47)
			Или (КодТекущегоСимвола >= 58 И КодТекущегоСимвола <= 64)
			Или (КодТекущегоСимвола >= 91 И КодТекущегоСимвола <= 96)
			Или КодТекущегоСимвола = 8470);
		Если Не СимволРазрешен Тогда
			ЗапрещенныеСимволы.Добавить(ТекущийСимвол);
		КонецЕсли;
		
		Сч = Сч + 1;
		
	КонецЦикла;
	
	Возврат ОбщегоНазначенияКлиентСервер.СвернутьМассив(
		ЗапрещенныеСимволы);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает идентификатор участника "UNKNOWN".
//
// Возвращаемое значение:
//  Строка - идентификатор.
//
Функция ИдентификаторНеизвестногоУчастника() Экспорт
	
	Возврат "UNKNOWN";
	
КонецФункции

// Формирует текст подсказки настройки подключения к Системе быстрых платежей.
//
// Параметры:
//  НаименованиеУчастника - Строка - наименование банка участника СБП;
//  ПараметрыПодсказки - Структура - результат создания параметров подсказки:
//   * АдресЛичногоКабинета - Строка - ссылка для перехода в личный кабинет;
//   * ПартнерАгентаСБП - Строка - признак партнера Агента СБП;
//   * АдресСтраницыЗаявки - Строка - адрес страницы отправки заявки;
//   * ИдентификаторУчастника - Строка - идентификатор участника СБП.
//
// Возвращаемое значение:
//  Строка, ФорматированнаяСтрока - подсказка при настройке подключения.
//
Функция ТекстПодсказкиПодключенияБезФорматирования(НаименованиеУчастника, ПараметрыПодсказки) Экспорт
	
	Подсказка = "";
	Если ПараметрыПодсказки.ПартнерАгентаСБП Тогда
		Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для подключения к Системе быстрых платежей заполните настройки."
					+ " Получить данные для настройки можно в <a href = ""%1"">Агенте 1С:СБП</a> для %2.'"),
					ПараметрыПодсказки.АдресЛичногоКабинета,
					НаименованиеУчастника);
	ИначеЕсли ЗначениеЗаполнено(ПараметрыПодсказки.АдресЛичногоКабинета) Тогда
		Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для подключения к Системе быстрых платежей заполните настройки."
					+ " Получить данные для настройки можно в <a href = ""%1"">%2</a>.'"),
					ПараметрыПодсказки.АдресЛичногоКабинета,
					НаименованиеУчастника);
	Иначе
		Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для подключения к Системе быстрых платежей заполните настройки"
				+ " или отправьте <a href = ""%1"">заявку на подключение</a> в %2.'"),
					ПараметрыПодсказки.АдресСтраницыЗаявки,
					НаименованиеУчастника);
	КонецЕсли;
	
	Если ПараметрыПодсказки.ИдентификаторУчастника = "1C-SBP" Тогда
		Подсказка = Подсказка
			+ Символы.ПС
			+ Символы.ПС
			+ НСтр("ru = 'Список доступных к подключению банков можно посмотреть в"
				+ " <a href = ""https://sbp.1c.ru/ui/notPartnerBanks"">Агенте 1С:СБП</a>.'");
	КонецЕсли;
	
	Возврат Подсказка
	
КонецФункции

#КонецОбласти
