#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("СвойстваДокумента") Тогда
		ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		
		// Текущее состояние набора помещается во временную таблицу,
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	СуммыДокументовВВалютахУчета.Регистратор КАК Регистратор,
		|	СуммыДокументовВВалютахУчета.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	СуммыДокументовВВалютахУчета.СуммаБезНДС КАК СуммаБезНДС,
		|	СуммыДокументовВВалютахУчета.СуммаНДС КАК СуммаНДС,
		|	СуммыДокументовВВалютахУчета.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|	СуммыДокументовВВалютахУчета.СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов,
		|	СуммыДокументовВВалютахУчета.Период КАК Период,
		|	СуммыДокументовВВалютахУчета.СтавкаНДС КАК СтавкаНДС,
		|	СуммыДокументовВВалютахУчета.ОбъектРасчетов КАК ОбъектРасчетов,
		|	СуммыДокументовВВалютахУчета.ПересчитыватьПоДаннымРасчетов КАК ПересчитыватьПоДаннымРасчетов
		|ПОМЕСТИТЬ СуммыДокументовВВалютахУчетаПередЗаписью
		|ИЗ
		|	РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
		|ГДЕ
		|	СуммыДокументовВВалютахУчета.Регистратор = &Регистратор
		|	И НЕ &ЭтоНовый
		|	И НЕ &ОбменДанными
		|");
		
		Запрос.УстановитьПараметр("Регистратор",  Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ЭтоНовый",     ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
		Запрос.УстановитьПараметр("ОбменДанными", ОбменДанными.Загрузка);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка ОбменДанными.Загрузка не требуется, т.к. данный объект в РИБ при записи должен создавать задания.
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		
		Запрос = Новый Запрос;
		
		МассивТекстовЗапроса = Новый Массив;
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Таблица.Период КАК Период,
		|	Таблица.Регистратор КАК Регистратор,
		|	Таблица.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	Таблица.СтавкаНДС КАК СтавкаНДС,
		|	Таблица.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Таблица.ПересчитыватьПоДаннымРасчетов КАК ПересчитыватьПоДаннымРасчетов
		|ПОМЕСТИТЬ СуммыДокументовВВалютахУчетаИзменения
		|ИЗ
		|	(ВЫБРАТЬ
		|		СуммыДокументовВВалютахУчетаПередЗаписью.Регистратор КАК Регистратор,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.СуммаБезНДС КАК СуммаБезНДС,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.СуммаНДС КАК СуммаНДС,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.Период КАК Период,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.СтавкаНДС КАК СтавкаНДС,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.ОбъектРасчетов КАК ОбъектРасчетов,
		|		СуммыДокументовВВалютахУчетаПередЗаписью.ПересчитыватьПоДаннымРасчетов КАК ПересчитыватьПоДаннымРасчетов
		|	ИЗ
		|		СуммыДокументовВВалютахУчетаПередЗаписью КАК СуммыДокументовВВалютахУчетаПередЗаписью
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		СуммыДокументовВВалютахУчета.Регистратор,
		|		СуммыДокументовВВалютахУчета.ИдентификаторСтроки,
		|		-СуммыДокументовВВалютахУчета.СуммаБезНДС,
		|		-СуммыДокументовВВалютахУчета.СуммаНДС,
		|		-СуммыДокументовВВалютахУчета.СуммаВзаиморасчетов,
		|		-СуммыДокументовВВалютахУчета.СуммаНДСВзаиморасчетов,
		|		СуммыДокументовВВалютахУчета.Период,
		|		СуммыДокументовВВалютахУчета.СтавкаНДС,
		|		СуммыДокументовВВалютахУчета.ОбъектРасчетов,
		|		СуммыДокументовВВалютахУчета.ПересчитыватьПоДаннымРасчетов
		|	ИЗ
		|		РегистрСведений.СуммыДокументовВВалютахУчета КАК СуммыДокументовВВалютахУчета
		|	ГДЕ
		|		СуммыДокументовВВалютахУчета.Регистратор = &Регистратор) КАК Таблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
		|		ПО Таблица.Регистратор = ДанныеПервичныхДокументов.Документ
		|
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ИдентификаторСтроки,
		|	Таблица.Регистратор,
		|	Таблица.ОбъектРасчетов,
		|	Таблица.Период,
		|	Таблица.СтавкаНДС,
		|	Таблица.ПересчитыватьПоДаннымРасчетов
		|
		|ИМЕЮЩИЕ
		|	СУММА(Таблица.СуммаБезНДС) <> 0
		|	ИЛИ СУММА(Таблица.СуммаНДС) <> 0
		|	ИЛИ СУММА(Таблица.СуммаВзаиморасчетов) <> 0
		|	ИЛИ СУММА(Таблица.СуммаНДСВзаиморасчетов) <> 0";
		МассивТекстовЗапроса.Добавить(ТекстЗапроса);
		
		МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ СуммыДокументовВВалютахУчетаПередЗаписью");
		
		Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
		
		Запрос.ВыполнитьПакет();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
