#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет данные обработки, исходя из входящих парамтеров ее использования.
//
// Параметры:
//  КлючевыеПараметры - см. ОбеспечениеВДокументахКлиентСервер.КлючевыеПараметрыФормыЗапросаКоличестваИСерий
//  ДанныеЗаполнения - см. ОбеспечениеВДокументахКлиентСервер.ПараметрыФормыЗапросаКоличестваИСерий
//
Процедура Заполнить(КлючевыеПараметры, ДанныеЗаполнения) Экспорт
	
	// Параметры - реквизиты объекта.
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,
		"Номенклатура,
		|Характеристика,
		|Склад,
		|Назначение,
		|КоличествоОформлено,
		|ВариантОбеспеченияДоИзменения,
		|Регистратор,
		|Цена,
		|ВидЦены,
		|Упаковка,
		|Валюта,
		|Дата,
		|ЦенаВключаетНДС,
		|БезОтбораПоВключениюНДСВЦену,
		|Соглашение,
		|Партнер,
		|ИспользуетсяЦенообразование25");
	
	// Вариант обеспечения, Обособленно.
	Если КлючевыеПараметры.ПодборТоваров Тогда
		
		ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры");
		
		Если Не ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор Тогда
		ВариантИФлагПоУмолчанию = ОбеспечениеВДокументахКлиентСервер.ВариантИФлагПоУмолчаниюДляПодбора(
			ТипНоменклатуры,
			ДанныеЗаполнения.ДопустимыеОбособленныеДействия,
			ДанныеЗаполнения.ДопустимыеНеобособленныеДействия,
			КлючевыеПараметры.ОграничиватьВариантыОбеспечения,
			ДанныеЗаполнения.ВариантОбеспеченияИФлагОбособленно);
		
			ВариантОбеспечения = ВариантИФлагПоУмолчанию.ВариантОбеспечения;
			Обособленно = ВариантИФлагПоУмолчанию.Обособленно;
		Иначе
			Обособленно = ДанныеЗаполнения.ДопустимыеОбособленныеДействия.Количество() > 0 И ДанныеЗаполнения.ОбособленныйНабор;
		КонецЕсли;
		
	Иначе
		ВариантОбеспечения = ДанныеЗаполнения.ВариантОбеспеченияПоДокументу;
		Обособленно = ДанныеЗаполнения.ОбособленноПоДокументу;
	КонецЕсли;
	
	// Упаковка.
	Если Упаковка.Пустая() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ИспользоватьУпаковки") Тогда
		Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(Номенклатура);
	КонецЕсли;
	
	// Количество.
	КоличествоУпаковок = 1;
	Если Не КлючевыеПараметры.ПодборТоваров Тогда
		КоличествоУпаковок = ДанныеЗаполнения.КоличествоПоДокументу;
	КонецЕсли;
	
	Количество = КоличествоУпаковок * Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	
	Если КлючевыеПараметры.ПодборТоваров Тогда
		КоличествоУпаковок = 1;
		Количество = КоличествоУпаковок * Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);

		Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор Тогда
			
			// Параметры варианта комплектации.
			ПараметрыВариантаКомплектации = НаборыВызовСервера.ПараметрыВариантаКомплектацииНоменклатуры(Номенклатура, Характеристика);
			Если ПараметрыВариантаКомплектации <> Неопределено Тогда
				ВариантКомплектацииНоменклатуры = ПараметрыВариантаКомплектации.ВариантКомплектацииНоменклатуры;
				ВариантРасчетаЦеныНабора        = ПараметрыВариантаКомплектации.ВариантРасчетаЦеныНабора;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Таб. часть Состав набора.
	Если Не ВариантКомплектацииНоменклатуры.Пустая() Тогда
	
		МассивКомплектующих = Обработки.ЗапросКоличестваИСерий.Комплектующие(ЭтотОбъект, ДанныеЗаполнения.Склады);
		Для Каждого СтрокаТЧ Из МассивКомплектующих Цикл
			НоваяКомплектующая = СоставНабора.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяКомплектующая, СтрокаТЧ);
		КонецЦикла;
		
		Обработки.ЗапросКоличестваИСерий.СоставНабораРассчитатьКоличествоПодобрать(ЭтотОбъект);
		
		// В наличии и Доступно по набору.
		ВНаличии = 0;
		Доступно = 0;
		
		ВНаличииНаборов = Неопределено;
		ДоступноНаборов = Неопределено;
		Для Каждого Строка Из СоставНабора Цикл
			
			ВНаличииВСтроке = 0;
			ДоступноВСтроке = 0;
			Если Строка.КоличествоУпаковок <> 0 Тогда
				ВНаличииВСтроке = Цел(Строка.ВНаличии / Строка.КоличествоУпаковок);
				ДоступноВСтроке = Цел(Строка.Доступно / Строка.КоличествоУпаковок);
			КонецЕсли;
			
			Если ВНаличииНаборов = Неопределено Или ВНаличииВСтроке < ВНаличииНаборов Тогда
				ВНаличииНаборов = ВНаличииВСтроке;
			КонецЕсли;
			
			Если ДоступноНаборов = Неопределено Или ДоступноВСтроке < ДоступноНаборов Тогда
				ДоступноНаборов = ДоступноВСтроке;
			КонецЕсли;
			
		КонецЦикла;
		ВНаличии = ВНаличииНаборов;
		Доступно = ДоступноНаборов;
		
	КонецЕсли;
	
	// Таб. часть Товары.
	ЗаполнитьТовары(КлючевыеПараметры, ДанныеЗаполнения);
	
	// Индекс строки документа в табличной части Товары.
	НайденнаяСтрока = Товары.Найти(Истина, "ЭтоСтрокаДокумента");
	ИндексСтрокиДокумента = ?(НайденнаяСтрока = Неопределено, -1, Товары.Индекс(НайденнаяСтрока));
	
	// Виды цен, Цена.
	Обработки.ЗапросКоличестваИСерий.ЗаполнитьВидыЦен(ЭтотОбъект, КлючевыеПараметры.РедактироватьВидЦены);
	Обработки.ЗапросКоличестваИСерий.УстановитьЦенуПоВидуЦены(ЭтотОбъект, КлючевыеПараметры);
	Обработки.ЗапросКоличестваИСерий.УстановитьЦенуПоСоставуНабора(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТовары(КлючевыеПараметры, ДанныеЗаполнения)
	
	ПодборТоваров                    = КлючевыеПараметры.ПодборТоваров;
	ПодборСерий                      = КлючевыеПараметры.ПодборСерий;
	ВыборСерии                       = КлючевыеПараметры.ВыборСерии;
	Подразделение                    = ДанныеЗаполнения.Подразделение;
	АдресДоступныеОстатки            = ДанныеЗаполнения.АдресДоступныеОстатки;
	РазбиватьСтрокиЗапрещено         = ДанныеЗаполнения.РазбиватьСтрокиЗапрещено;
	ПараметрыУказанияСерий           = ДанныеЗаполнения.ПараметрыУказанияСерий;
	СкладПоДокументу                 = ДанныеЗаполнения.СкладПоДокументу;
	АдресТаблицыПодобраноРанее       = ДанныеЗаполнения.АдресТаблицыПодобраноРанее;
	
	Товары.Очистить();
	
	ТаблицаОстатковТоваров  = Неопределено;
	Если ПодборТоваров Тогда
		
		Если ВариантКомплектацииНоменклатуры.Пустая() Тогда
			ТаблицаАналитикиТоваров = СоставНабора.ВыгрузитьКолонки("Номенклатура,Характеристика");
			НоваяСтрока = ТаблицаАналитикиТоваров.Добавить();
			НоваяСтрока.Номенклатура   = Номенклатура;
			НоваяСтрока.Характеристика = Характеристика;
		Иначе
			ТаблицаАналитикиТоваров = СоставНабора.Выгрузить(, "Номенклатура,Характеристика");
		КонецЕсли;
		
		ТаблицаПодобраноРанее = ПолучитьИзВременногоХранилища(АдресТаблицыПодобраноРанее);
		
		ТаблицаОстатковТоваров = ОбеспечениеВДокументахСервер.СвободныеОстаткиДляПодбораТоваров(
			ТаблицаАналитикиТоваров,
			ТаблицаПодобраноРанее,
			ДанныеЗаполнения.Склады,
			ДанныеЗаполнения.Назначение,
			Подразделение);
		
		ОтборСтрок = Новый Структура("Номенклатура,Характеристика");
		
		ТаблицаОстатковТоваров.Индексы.Добавить("Номенклатура,Характеристика");
		ТаблицаОстатковТоваров.Колонки.Добавить("ИндексТовараДляОтбора");
		Если Не ВариантКомплектацииНоменклатуры.Пустая() Тогда
			Для Индекс = 0 По СоставНабора.Количество() - 1 Цикл
				ЗаполнитьЗначенияСвойств(ОтборСтрок, СоставНабора[Индекс]);
				НайденныеСтроки = ТаблицаОстатковТоваров.НайтиСтроки(ОтборСтрок);
				Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
					СтрокаТаблицы.ИндексТовараДляОтбора = Индекс;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
	Иначе
		
		ТаблицаОстатковТоваров = ПолучитьИзВременногоХранилища(АдресДоступныеОстатки);
		УдалитьИзВременногоХранилища(АдресДоступныеОстатки);
		
	КонецЕсли;
	
	Товары.Загрузить(ТаблицаОстатковТоваров);
	Для Каждого Строка Из Товары Цикл
		Строка.ЕстьОстатокВГрафике = Строка.ПоГрафику > 0;
		Строка.ЕстьОстатокНаСкладе = Строка.ВНаличии > 0;
		Строка.Подразделение = Подразделение;
	КонецЦикла;
	Если ВыборСерии Тогда
		Для Каждого Строка Из Товары Цикл
			Строка.ЭтоСкладВыбраннойГруппы = Строка.Склад = СкладПоДокументу;
		КонецЦикла;
	КонецЕсли;
	
	// Заполнение колонки "СтатусУказанияСерий".
	Если ПодборСерий Тогда
		
		ТаблицаДляЗаполнения = Товары;
		ДопКолонкиДляУказанияСерий = КлючевыеПараметры.ДопКолонкиДляУказанияСерий;
		Если ДопКолонкиДляУказанияСерий <> Неопределено Тогда
			ТаблицаДляЗаполнения = Товары.Выгрузить();
			Для Каждого ДопКолонка Из ДопКолонкиДляУказанияСерий Цикл
				ТаблицаДляЗаполнения.Колонки.Добавить(ДопКолонка.Ключ);
			КонецЦикла;
			Для Каждого Строка Из ТаблицаДляЗаполнения Цикл
				ЗаполнитьЗначенияСвойств(Строка, ДопКолонкиДляУказанияСерий);
			КонецЦикла;
		КонецЕсли;
		
		Обработки.ЗапросКоличестваИСерий.ЗаполнитьСтатусУказанияСерииВТаблице(
			ВариантОбеспечения, ТаблицаДляЗаполнения, ПараметрыУказанияСерий, ДанныеЗаполнения.Склад);
		
		Если ДопКолонкиДляУказанияСерий <> Неопределено Тогда
			Товары.Загрузить(ТаблицаДляЗаполнения);
		КонецЕсли;
	
	КонецЕсли;
	
	// Заполнение колонки "ЭтоСтрокаДокумента".
	ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ТипНоменклатуры");
	СкладПодразделениеПоДокументу = ?(ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар, СкладПоДокументу,
	                                ?(ТипНоменклатуры = Перечисления.ТипыНоменклатуры.МногооборотнаяТара, СкладПоДокументу,
	                                ?(ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа, Подразделение,
	                                Неопределено)));
	
	Отбор = Новый Структура("Склад,Обособленно", СкладПодразделениеПоДокументу, Обособленно);
	НайденныеСтроки = Товары.НайтиСтроки(Отбор);
	
	// Строку документа нужно делать видимой независимо от режимов отображения остатка.
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].ЭтоСтрокаДокумента = Истина;
		НайденныеСтроки[0].ЕстьОстатокНаСкладе = Истина;
		НайденныеСтроки[0].ЕстьОстатокВГрафике = Истина;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли