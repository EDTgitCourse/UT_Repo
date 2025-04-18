
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПоказыватьРеализациюЧерезКомиссионера = Параметры.Свойство("ПоказыватьРеализациюЧерезКомиссионера") 
		И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах");
	
	Список.Параметры.УстановитьЗначениеПараметра("ВводОстатков", Параметры.Свойство("ЭтоВводОстатков"));
	УстановитьНедоступныеОтборыИзПараметров(Параметры.Отбор, Параметры.Свойство("ПоказыватьДоговорыРаздельнойЗакупки"),
		ПоказыватьРеализациюЧерезКомиссионера);
	
	Если Параметры.Свойство("Партнер") И Не ПоказыватьРеализациюЧерезКомиссионера Тогда
		
		Партнер = Параметры.Партнер;
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(Партнер, СписокПартнеров);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Партнер",
			СписокПартнеров,
			ВидСравненияКомпоновкиДанных.ВСписке,
			Неопределено,
			ЗначениеЗаполнено(Партнер));
		
		Список.Параметры.УстановитьЗначениеПараметра("СписокПартнеров", СписокПартнеров);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ОтборПоПартнеру",
			Истина,
			ВидСравненияКомпоновкиДанных.Равно);
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Партнер);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ПартнерПоУмолчанию",
			Партнер,
			ВидСравненияКомпоновкиДанных.Равно,
			Неопределено,
			Истина);
		
	Иначе
		
		Список.Параметры.УстановитьЗначениеПараметра("ПартнерПоУмолчанию", Справочники.Партнеры.ПустаяСсылка());
		
	КонецЕсли;
	
	Если Параметры.Свойство("Контрагент") И Не ПоказыватьРеализациюЧерезКомиссионера Тогда
		Контрагент = Параметры.Контрагент;
		
		УстановитьЭлементОтбораДинамическогоСписка(Список, Контрагент, "Контрагент");
	КонецЕсли;
	
	Если Параметры.Свойство("РазрешитьВыборФилиальныхДоговоров") Тогда
		Список.Параметры.УстановитьЗначениеПараметра("РазрешитьВыборФилиальныхДоговоров", Параметры.РазрешитьВыборФилиальныхДоговоров);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("РазрешитьВыборФилиальныхДоговоров", Ложь);
	КонецЕсли;
	
	Если Параметры.Свойство("РазрешитьВыборПартнера") Тогда
		Элементы.ОтборПартнер.Видимость			= Истина;
		Элементы.ОтборКонтрагент.Видимость		= Истина;
		Элементы.СписокОрганизация.Видимость	= Истина;
		Элементы.СписокКонтрагент.Видимость		= Истина;
		Элементы.СписокПартнер.Видимость		= Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("НалогообложениеНДС") Тогда
		УчетАгентскогоНДС = (Параметры.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НалоговыйАгентПоНДС);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"УчетАгентскогоНДС",
																				УчетАгентскогоНДС,
																				ВидСравненияКомпоновкиДанных.Равно,
																				Неопределено,
																				Истина);
	КонецЕсли;
		
	МассивХозяйственныхОпераций = Новый Массив;
	
	Если Параметры.Свойство("ПоказыватьЗакупкуПоИмпорту")
		И Параметры.Отбор.Свойство("ХозяйственнаяОперация")
		И Параметры.Отбор.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика Тогда
		
		МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
		МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);
		МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС);
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупкиТоваровВПути") Тогда
			ОперацииВПути = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту);
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивХозяйственныхОпераций, ОперацииВПути);
			ОперацииВПути = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивХозяйственныхОпераций, ОперацииВПути);
		КонецЕсли;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков")
			Или ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки") Тогда
			
			ОперацииВПути = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
			
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивХозяйственныхОпераций, ОперацииВПути);
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступныеПорядкиРасчетов") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"ПорядокРасчетов",
																				Параметры.ДоступныеПорядкиРасчетов,
																				ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	Если Параметры.Свойство("ТипыДоговоров") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"ТипДоговора", 
			Параметры.ТипыДоговоров, 
			ВидСравненияКомпоновкиДанных.ВСписке);
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПоказыватьПередачуНаКомиссию")
		И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
		
		Если МассивХозяйственныхОпераций.Количество() Тогда
			МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
		КонецЕсли;
	
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы, "ПоказыватьПередачуНаКомиссию", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		ГруппаОтбораКомиссии = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ГруппаОтбораКомиссии.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ГруппаОтбораКомиссии.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ГруппаОтбораКомиссии.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
		
		ГруппаОтбораКомиссии = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораКомиссии.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;
		
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомиссионныеПродажи25");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
	КонецЕсли;
	
	Если ПоказыватьРеализациюЧерезКомиссионера Тогда
		
		Если МассивХозяйственныхОпераций.Количество() Тогда
			МассивХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера);
		КонецЕсли;
	
		ГруппаОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор.Элементы, "ПоказыватьРеализациюЧерезКомиссионера", ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		ГруппаОтбораОбычная = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораОбычная.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
		ОтборЭлемента = ГруппаОтбораОбычная.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера;
		
		ДобавитьОтборКонтрагентПартнер(ГруппаОтбораОбычная, Параметры.Отбор, "Контрагент", "Партнер");
		
		ОтборЭлемента = ГруппаОтбораОбычная.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипДоговора");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ОтборЭлемента.ПравоеЗначение = Параметры.Отбор.ТипДоговора;
		
		ГруппаОтбораКомиссии = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораКомиссии.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера;

		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВестиРасчетыЧерезКонечныхПокупателей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;
		
		ДобавитьОтборКонтрагентПартнер(ГруппаОтбораКомиссии, Параметры.Отбор, "КомиссионерКонтрагент", "КомиссионерПартнер");
		
		ГруппаОтбораКомиссии = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораКомиссии.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.РеализацияЧерезКомиссионера;

		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВестиРасчетыЧерезКонечныхПокупателей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		ДобавитьОтборКонтрагентПартнер(ГруппаОтбораКомиссии, Параметры.Отбор, "Контрагент", "Партнер");
		
		ГруппаОтбораКомиссии = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбораКомиссии.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию;

		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВестиРасчетыЧерезКонечныхПокупателей");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		ОтборЭлемента = ГруппаОтбораКомиссии.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПорядокРасчетов");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.ПорядокРасчетов.ПоДоговорамНакладным;
		
		ДобавитьОтборКонтрагентПартнер(ГруппаОтбораКомиссии, Параметры.Отбор, "Контрагент", "Партнер");
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПереработкаВСтранахЕАЭС") Тогда
		
			
	КонецЕсли;
	
	Если МассивХозяйственныхОпераций.Количество() Тогда
	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
																				"ХозяйственнаяОперация", 
																				МассивХозяйственныхОпераций,
																				ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Параметры.Отбор.Очистить();
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Менеджер = Настройки.Получить("Менеджер");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		"Менеджер", 
		Менеджер, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Менеджер));
	
	Настройки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
	УстановитьЭлементОтбораДинамическогоСписка(Список, Менеджер, "Менеджер");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПартнерПриИзменении(Элемент)
	
	УстановитьЭлементОтбораДинамическогоСписка(Список, Партнер, "Партнер");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УстановитьЭлементОтбораДинамическогоСписка(Список, Контрагент, "Контрагент");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	ОчиститьСообщения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЭлементОтбораДинамическогоСписка(Список, РеквизитФормы, ИмяПоляДинамическогоСписка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, 
		ИмяПоляДинамическогоСписка, 
		РеквизитФормы, 
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(РеквизитФормы));
	
КонецПроцедуры

// Процедура устанавливает отборы, переданные в структуре. Отборы недоступны для изменения.
//
// Параметры:
//	СтруктураОтбора - Структура - Ключ: имя поля компоновки данных, Значение: значение отбора.
//
&НаСервере
Процедура УстановитьНедоступныеОтборыИзПараметров(СтруктураОтбора, ПоказыватьДоговорРаздельнойЗакупки, ПоказыватьРеализациюЧерезКомиссионера)
	
	Если СтруктураОтбора.Свойство("Владелец") Тогда
		СтруктураОтбора.Удалить("Владелец");
	КонецЕсли;
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		ЗначениеОтбора = ЭлементОтбора.Значение;
		
		Если ПоказыватьРеализациюЧерезКомиссионера = Истина
			И (ЭлементОтбора.Ключ = "Контрагент" 
				Или ЭлементОтбора.Ключ = "Партнер"
				Или ЭлементОтбора.Ключ = "ТипДоговора") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "Организация" Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"ОтборПоОрганизации",
				Истина,
				ВидСравненияКомпоновкиДанных.Равно);
				
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"ОрганизацияОтбора",
				ЗначениеОтбора,
				ВидСравненияКомпоновкиДанных.Равно,
				,
				Истина);
				
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Список,
				"Организация",
				ЗначениеОтбора);
			
			Продолжить;
			
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "Контрагент"
			И ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			
			РеквизитОтбора = ?(ЗначениеЗаполнено(ЗначениеОтбора),
								ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеОтбора, "Партнер"),
								Справочники.Партнеры.ПустаяСсылка());
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"Партнер",
				РеквизитОтбора,
				ВидСравненияКомпоновкиДанных.Равно);
			
			Продолжить;
			
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "ХозяйственнаяОперация" Тогда
			
			Если ЗначениеОтбора = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности Тогда
				
				ЗначениеОтбора = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
				
			ИначеЕсли ПоказыватьДоговорРаздельнойЗакупки
				И (ЗначениеОтбора = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика
					Или ЗначениеОтбора = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту
					Или ЗначениеОтбора = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС) Тогда
				
				ЗначениеОтбора = ЗакупкиСервер.ХозяйственныеОперацииПоОсновной(ЭлементОтбора.Значение);
				
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПоказыватьРеализациюЧерезКомиссионера = Истина
			И ЭлементОтбора.Ключ = "ПорядокРасчетов" Тогда
			Если ТипЗнч(ЗначениеОтбора) = Тип("ФиксированныйМассив") Тогда
				ЗначениеОтбораПорядокРасчетов = Новый Массив(ЗначениеОтбора);
			Иначе
				ЗначениеОтбораПорядокРасчетов = Новый Массив();
				ЗначениеОтбораПорядокРасчетов.Добавить(ЗначениеОтбора);
			КонецЕсли;
			ЗначениеОтбораПорядокРасчетов.Добавить(Перечисления.ПорядокРасчетов.ПоДоговорамНакладным);
			ЗначениеОтбора = ЗначениеОтбораПорядокРасчетов;
		КонецЕсли;
		
		Если ТипЗнч(ЗначениеОтбора) = Тип("Массив")
			Или ТипЗнч(ЗначениеОтбора) = Тип("ФиксированныйМассив") Тогда
			
			ВидСравненияКомпоновки = ВидСравненияКомпоновкиДанных.Всписке;
			
		Иначе
			ВидСравненияКомпоновки = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			ЭлементОтбора.Ключ,
			ЗначениеОтбора,
			ВидСравненияКомпоновки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОтборКонтрагентПартнер(ГруппаОтбора, СтруктураОтбора, ИмяСвойстваКонтрагент, ИмяСвойстваПартнер)
	
	ЗначениеОтбора = Неопределено;
	Если СтруктураОтбора.Свойство("Контрагент", ЗначениеОтбора) Тогда
		
		ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяСвойстваКонтрагент);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ЗначениеОтбора;
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
			РеквизитОтбора = ?(ЗначениеЗаполнено(ЗначениеОтбора),
								ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначениеОтбора, "Партнер"),
								Справочники.Партнеры.ПустаяСсылка());
		Иначе
			РеквизитОтбора = СтруктураОтбора.Партнер;
		КонецЕсли;
		
		СписокПартнеров = Новый СписокЗначений;
		ПартнерыИКонтрагенты.ЗаполнитьСписокПартнераСРодителями(РеквизитОтбора, СписокПартнеров);
		
		Если СписокПартнеров.Количество() = 0 Тогда
			ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяСвойстваПартнер);
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = РеквизитОтбора;
		Иначе
			ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяСвойстваПартнер);
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			ОтборЭлемента.ПравоеЗначение = СписокПартнеров;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
