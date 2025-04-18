#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЗначенияФункциональныхОпций = Новый Структура("БазоваяВерсия", ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
		
		ПараметрКоманды = Параметры.ПараметрКоманды;
		
		Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
			ЭтоМассив = Истина;
			Если ПараметрКоманды.Количество() > 0 Тогда
				ПервыйЭлемент = ПараметрКоманды[0];
			Иначе
				ПервыйЭлемент = Неопределено;
			КонецЕсли;
		Иначе
			ЭтоМассив = Ложь;
			ПервыйЭлемент = ПараметрКоманды;
		КонецЕсли;
		
		Если ТипЗнч(ПервыйЭлемент) = Тип("ДокументСсылка.СверкаВзаиморасчетов") Тогда
			ЭтаФорма.ФормаПараметры.Отбор = Новый Структура("СверкаВзаиморасчетов", ПервыйЭлемент);
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = "СверкаВзаиморасчетов";
			Параметры.КлючНазначенияИспользования = "СверкаВзаиморасчетов";
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ПоСверкеВзаиморасчетовКонтекст", 
			                                                                     ЗначенияФункциональныхОпций.БазоваяВерсия);
		
		ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Контрагенты") Тогда
			ЭтаФорма.ФормаПараметры.Отбор = Новый Структура("Контрагент", ПараметрКоманды);
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = "Контрагент";
			Параметры.КлючНазначенияИспользования = "Контрагент";
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ПоКонтрагентамКонтекст", 
			                                                                     ЗначенияФункциональныхОпций.БазоваяВерсия);

		ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ЭтаФорма.ФормаПараметры.Отбор = Новый Структура("Договор", ПараметрКоманды);
			ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = "Договор";
			Параметры.КлючНазначенияИспользования = "Договор";
			Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("РасчетыСПартнерами", 
			                                                                     ЗначенияФункциональныхОпций.БазоваяВерсия);
			
		ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") ИЛИ
			      ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
			
			СформироватьПараметрыФормыНаСервере(ПараметрКоманды, ЭтаФорма.ФормаПараметры, Параметры, 
			                                    ПервыйЭлемент, ЭтоМассив, ЗначенияФункциональныхОпций.БазоваяВерсия);
			
		КонецЕсли;
		
	КонецЕсли;
	
	
	ФормаПараметры = ЭтаФорма.ФормаПараметры;
	
	Если ФормаПараметры.Свойство("Отбор")
	 И ФормаПараметры.Отбор.Свойство("СверкаВзаиморасчетов") Тогда
	   
		Реквизиты = Документы.СверкаВзаиморасчетов.РеквизитыДокумента(ФормаПараметры.Отбор.СверкаВзаиморасчетов);
		Если Реквизиты <> Неопределено Тогда
			Если ЗначениеЗаполнено(Реквизиты.Организация) Тогда	
				ФормаПараметры.Отбор.Вставить("Организация", Реквизиты.Организация);
			КонецЕсли;
			Если ЗначениеЗаполнено(Реквизиты.Контрагент) Тогда
				Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда
					ФормаПараметры.Отбор.Вставить("Контрагент", Реквизиты.Контрагент);
				Иначе
					ФормаПараметры.Отбор.Вставить("Партнер", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Контрагент,"Партнер"));
				КонецЕсли;
			КонецЕсли;
			Период = Новый СтандартныйПериод;
			Период.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод;
			Период.ДатаНачала = Реквизиты.НачалоПериода;
			Период.ДатаОкончания = Реквизиты.КонецПериода;
			ФормаПараметры.Отбор.Вставить("Период", Период);
		КонецЕсли;
		ФормаПараметры.Отбор.Удалить("СверкаВзаиморасчетов");
	КонецЕсли;

КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	
	ПараметрДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДанныеПоРасчетам");
	ПользовательскаяНастройка = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(
		ПараметрДанных.ИдентификаторПользовательскойНастройки);
	
	Если ПользовательскаяНастройка <> Неопределено Тогда
		Если ПользовательскаяНастройка.Значение = 2 // В валюте упр. учета
			ИЛИ ПользовательскаяНастройка.Значение = 3 // В валюте регл. учета
		Тогда
			#Область АктуализацияВзаиморасчетов
			УстановитьПривилегированныйРежим(Истина);
			ПоляОтбора = РаспределениеВзаиморасчетовВызовСервера.ПоляОтбораПоУмолчанию();
			ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
			РаспределениеВзаиморасчетовВызовСервера.ВосстановитьРасчетыПоОтборам(КомпоновщикНастроек, ПоляОтбора, ДопСвойства);
			УстановитьПривилегированныйРежим(Ложь);
			#КонецОбласти		
		КонецЕсли;		
	КонецЕсли;
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	#Область ПроверкаВзаиморасчетов
	РегистрыСведений.ЗаданияКРаспределениюРасчетовСПоставщиками.ВывестиАктуальностьРасчета(ДокументРезультат, ДопСвойства);
	#КонецОбласти
	
	//Предупреждение о невыполенном распределении взаиморасчетов.
	ВзаиморасчетыСервер.ВывестиПредупреждениеОбОбновлении(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ВспомогательныеПараметры = Новый Массив;
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметры);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы, ПользовательскиеНастройки = Ложь)
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
	
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
		ПользНастройкаПериода.Использование = Истина;
		СтандартныйПериод = ПользНастройкаПериода.Значение; //СтандартныйПериод
		ФиксированныйСтандартныйПериод = ФиксНастройкаПериода.Значение; //СтандартныйПериод
		СтандартныйПериод.ДатаНачала = ФиксированныйСтандартныйПериод.ДатаНачала;
		СтандартныйПериод.ДатаОкончания = ФиксированныйСтандартныйПериод.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
		
	КонецЕсли;
КонецПроцедуры

// Описание
// 
// Параметры:
// 	КомпоновщикНастроекФормы - КомпоновщикНастроекКомпоновкиДанных
// 	ИмяПараметра - Строка - Описание
// Возвращаемое значение:
// 	ЗначениеПараметраНастроекКомпоновкиДанных - Описание
Функция ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроекФормы.ФиксированныеНастройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Возврат ПараметрДанных;

КонецФункции

// Описание
// 
// Параметры:
// 	КомпоновщикНастроекФормы - КомпоновщикНастроекКомпоновкиДанных 
// 	ИмяПараметра - Строка - Описание
// Возвращаемое значение:
// 	ЗначениеПараметраНастроекКомпоновкиДанных - Описание
Функция ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)

	ПараметрДанных = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПараметрПользовательскойНастройки = КомпоновщикНастроекФормы.ПользовательскиеНастройки.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Возврат ПараметрПользовательскойНастройки;
		Иначе
			Возврат ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	Возврат Неопределено;

КонецФункции

Процедура СформироватьПараметрыФормыНаСервере(ПараметрКоманды, ПараметрыФормы, Параметры, ПервыйЭлемент, ЭтоМассив, ЭтоБазовая)
	
	Если ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.Партнеры") Тогда
		
		Если ЭтоМассив Тогда
			ЕстьПодчиненныеПартнеры = Ложь;
			Для Каждого ЭлементПараметраКоманды Из ПараметрКоманды Цикл
				Если ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ЭлементПараметраКоманды) Тогда
					ЕстьПодчиненныеПартнеры = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ЕстьПодчиненныеПартнеры = ПартнерыИКонтрагенты.ЕстьПодчиненныеПартнеры(ПараметрКоманды);
		КонецЕсли;
		
		Если ЕстьПодчиненныеПартнеры Тогда
			ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
			ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
			ЗначениеОтбора = ПараметрКоманды;
			Если ЭтоМассив Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(ПараметрКоманды);
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
			Иначе
				ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
			КонецЕсли;
			ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
			ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
			Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
			ПараметрыФормы.КлючНазначенияИспользования = "ГруппаПартнеров";
			Параметры.КлючНазначенияИспользования = "ГруппаПартнеров";
			
		Иначе
			ПараметрыФормы.Отбор = Новый Структура("Партнер", ПараметрКоманды);
			ПараметрыФормы.КлючНазначенияИспользования = "Партнер";
			Параметры.КлючНазначенияИспользования = "Партнер";
			
		КонецЕсли;
		
		Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ПоПартнерамКонтекст", ЭтоБазовая);
		
	ИначеЕсли ТипЗнч(ПервыйЭлемент) = Тип("СправочникСсылка.СегментыПартнеров") Тогда
		
		ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных();
		ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Партнер");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		
		ЭлементОтбора.ПравоеЗначение = СегментыВызовСервера.СписокЗначений(ПервыйЭлемент);
		ПараметрыФормы.ФиксированныеНастройки = ФиксированныеНастройки;
		Параметры.ФиксированныеНастройки = ФиксированныеНастройки;
		
		ПараметрыФормы.КлючНазначенияИспользования = "СегментПартнеров";
		Параметры.КлючНазначенияИспользования = "СегментПартнеров";
		Параметры.КлючВарианта = ИмяКлючаВариантаВЗависимостиОтФлагаБазовая("ПоПартнерамКонтекст", ЭтоБазовая);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяКлючаВариантаВЗависимостиОтФлагаБазовая(ИмяКлючаВарианта, ЭтоБазовая)
	
	Если Не ЭтоБазовая Тогда
		Возврат ИмяКлючаВарианта;
	КонецЕсли;
	
	Если ИмяКлючаВарианта = "РасчетыСПартнерами" Тогда
		Возврат "РасчетыСПартнерамиБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ПоКонтрагентамКонтекст" Тогда
		Возврат "ПоКонтрагентамКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ПоПартнерамКонтекст" Тогда
		Возврат "ПоПартнерамКонтекстБазовая";
	ИначеЕсли ИмяКлючаВарианта = "ПоСверкеВзаиморасчетовКонтекст" Тогда
		Возврат "ПоСверкеВзаиморасчетовКонтекстБазовая";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли