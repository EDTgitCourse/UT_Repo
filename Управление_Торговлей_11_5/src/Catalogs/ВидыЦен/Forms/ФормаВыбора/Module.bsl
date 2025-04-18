#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Заголовок", Заголовок);
	
	Элементы.Список.ИзменятьСоставСтрок = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.ВыводитьПроизвольныйВидЦен Тогда
		
		ИспользуетсяЦенообразование25 = Истина;
		Если Не Параметры.Свойство("ИспользуетсяЦенообразование25", ИспользуетсяЦенообразование25) Тогда
			ИспользуетсяЦенообразование25 = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
		КонецЕсли;
		
		ВладелецИндивидуальногоВидаЦен = Неопределено;
		ИспользоватьСоглашенияСКлиентами = Ложь;
		Если ИспользуетсяЦенообразование25 И Параметры.Свойство("ИспользоватьСоглашенияСКлиентами", ИспользоватьСоглашенияСКлиентами) Тогда
			Если ИспользоватьСоглашенияСКлиентами Тогда
				ВладелецИндивидуальногоВидаЦен = ?(Параметры.Свойство("Соглашение"), Параметры.Соглашение, Неопределено);
			Иначе
				ВладелецИндивидуальногоВидаЦен = ?(Параметры.Свойство("Партнер"), Параметры.Партнер, Неопределено);
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВладелецИндивидуальногоВидаЦен) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ВладелецИндивидуальногоВидаЦен", ВладелецИндивидуальногоВидаЦен, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"ВладелецИндивидуальногоВидаЦен",
																				ВладелецИндивидуальногоВидаЦен,
																				ВидСравненияКомпоновкиДанных.Равно,
																				"ОтборПоУмолчанию",
																				Истина);
		Иначе
			Если Не Параметры.Отбор.Свойство("Назначение") Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																					"Назначение",
																					Перечисления.НазначенияВидовЦен.Общий,
																					ВидСравненияКомпоновкиДанных.Равно,
																					"ОтборПоУмолчанию",
																					Истина);
			КонецЕсли;
		КонецЕсли;
		
		Параметры.Отбор.Удалить("Назначение");
		
		Если Параметры.ВидыЦен.Количество() Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"Ссылка",
																				Параметры.ВидыЦен,
																				ВидСравненияКомпоновкиДанных.ВСписке,
																				"ОтборПоУмолчанию",
																				Истина);
			
		КонецЕсли;
	КонецЕсли;
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
