#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
// Возвращает текстовое описание классификации по значениям ABC/XYZ классов
//
// Параметры:
//  ABC - ПеречислениеСсылка.ABCКлассификация - значение ABC классификации,
//  XYZ - ПеречислениеСсылка.XYZКлассификация - значение XYZ классификации.
//
// Возвращаемое значение:
//   Строка - строковое представление класса
//
Функция ПолучитьПредставлениеКлассификации(ABC, XYZ) Экспорт

	ПредставлениеABC = ПолучитьОписаниеКласса(ABC);
	ПредставлениеXYZ = ПолучитьОписаниеКласса(XYZ);
	
	Возврат ПредставлениеABC + ", " + ПредставлениеXYZ;

КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Возвращает текстовое описание класса по его значению
//
// Параметры:
//  ЗначениеКласса - ПеречислениеСсылка.ABCКлассификация, ПеречислениеСсылка.XYZКлассификация - значение класса, для
//      которого нужно определить описание.
//
// Возвращаемое значение:
//   Строка - строковое представление класса
//
Функция ПолучитьОписаниеКласса(ЗначениеКласса)

	Если ЗначениеКласса = Перечисления.ABCКлассификация.ПустаяСсылка() Тогда
		Возврат НСтр("ru='потенциальный клиент(ABC)'");
	ИначеЕсли ЗначениеКласса = Перечисления.ABCКлассификация.НеКлассифицирован Тогда
		Возврат НСтр("ru='потерянный клиент(ABC)'");
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.ПустаяСсылка() Тогда
		Возврат НСтр("ru='потенциальный клиент(XYZ)'");
	ИначеЕсли ЗначениеКласса = Перечисления.XYZКлассификация.НеКлассифицирован Тогда
		Возврат НСтр("ru='потерянный клиент(XYZ)'");
	Иначе
		Возврат Строка(ЗначениеКласса);
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли