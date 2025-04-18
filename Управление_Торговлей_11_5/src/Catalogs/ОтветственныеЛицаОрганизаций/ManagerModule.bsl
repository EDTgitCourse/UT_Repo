
#Область ОбработчикиСобытий

// Обработчик события ОбработкаПолученияДанныхВыбора
//
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
		Если Параметры.Свойство("Отбор") Тогда
		
		// Заменим платформенный механизм формирования списка выбора,
		// т.к. необходим отбор по дате получения данных об ответственных лицах.
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора 		 = Новый СписокЗначений;
		
		СтрокаПоиска         = "";
		Параметры.Свойство("СтрокаПоиска", СтрокаПоиска);
		
		ТаблицаОтветственных = ОтветственныеЛицаВызовСервера.ПолучитьТаблицуОтветственныхЛицПоОтбору(Параметры.Отбор, Истина, СтрокаПоиска);
		
		Для Каждого ТекСтр Из ТаблицаОтветственных Цикл
			
			СтруктураЭлементаСписка = Новый Структура;
			СтруктураЭлементаСписка.Вставить("Значение", 		ТекСтр.Ссылка);
			СтруктураЭлементаСписка.Вставить("ПометкаУдаления", ТекСтр.ПометкаУдаления);
			СтруктураЭлементаСписка.Вставить("Предупреждение"); // стандартное сообщение
			
			ДанныеВыбора.Добавить(СтруктураЭлементаСписка);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли
