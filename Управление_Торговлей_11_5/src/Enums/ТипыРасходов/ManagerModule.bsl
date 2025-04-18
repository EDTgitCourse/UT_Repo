
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МассивИсключаемыхЗначений = Новый Массив;
	// Устаревшие значения
	МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.Производственные"));
	
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.ФормированиеСтоимостиВНА"));
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.ПроизводствоПродукции"));
	Иначе
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОбъектамВозникновенияЗатрат") Тогда
		МассивИсключаемыхЗначений.Добавить(ПредопределенноеЗначение("Перечисление.ТипыРасходов.ВозникновениеЗатратНаОбъектах"));
	КонецЕсли;
	
	ОбщегоНазначенияУТВызовСервера.ДоступныеДляВыбораЗначенияПеречисления(
		"ТипыРасходов",
		ДанныеВыбора,
		Параметры,
		МассивИсключаемыхЗначений);
	
КонецПроцедуры

#КонецОбласти

