#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный         = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачала            = Неопределено;
	ДатаОкончания         = Неопределено;
	ПлановаяДатаНачала    = Неопределено;
	ПлановаяДатаОкончания = Неопределено;
	Завершено             = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.УстановитьПризнакАктивен(Ссылка, (НЕ Завершено) И (Не ПометкаУдаления));
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ПлановаяДатаОкончания < ПлановаяДатаНачала
		И ЗначениеЗаполнено(ПлановаяДатаОкончания) Тогда
		
		ТекстСообщения = НСтр("ru = 'Плановая дата окончания не должна быть меньше чем плановая дата начала.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПлановаяДатаОкончания",, Отказ);
		
	КонецЕсли;
	
	Если ДатаОкончания < ДатаНачала
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ТекстСообщения = НСтр("ru = 'Фактическая дата окончания не должна быть меньше чем фактическая дата начала.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончания",, Отказ);
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПартнерыИКонтактныеЛица.Партнер");
		
		Для Каждого СтрокаПартнер Из ПартнерыИКонтактныеЛица Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаПартнер.Партнер) Тогда
				
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""Контрагент"" в строке %1 табличной части ""Контрагенты и контактные лица""'"), СтрокаПартнер.НомерСтроки);
				ПутьКТабЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПартнерыИКонтактныеЛица", СтрокаПартнер.НомерСтроки, "Партнер");
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, ПутьКТабЧасти,, Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли