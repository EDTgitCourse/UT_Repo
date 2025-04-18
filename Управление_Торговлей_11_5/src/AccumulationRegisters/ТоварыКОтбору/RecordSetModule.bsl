#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	ОбщегоНазначенияУТ.СвернутьНаборЗаписей(ЭтотОбъект, Истина);
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу "ДвиженияТоварыВЯчейкахЗаписью",
	// чтобы при записи получить изменение нового набора относительно текущего.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",    ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия,
	|	Таблица.Распоряжение КАК Распоряжение,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Отобрано
	|		ИНАЧЕ -Таблица.Отобрано
	|	КОНЕЦ КАК ОтобраноПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.Отбирается
	|		ИНАЧЕ -Таблица.Отбирается
	|	КОНЕЦ КАК ОтбираетсяПередЗаписью,
	|	ВЫБОР
	|		КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|			ТОГДА Таблица.КОтбору
	|		ИНАЧЕ -Таблица.КОтбору
	|	КОНЕЦ КАК КОтборуПередЗаписью
	|ПОМЕСТИТЬ ДвиженияТоварыКОтборуПередЗаписью
	|ИЗ
	|	РегистрНакопления.ТоварыКОтбору КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|	И Таблица.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)";
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаИзменений.Номенклатура КАК Номенклатура,
	|	ТаблицаИзменений.Характеристика КАК Характеристика,
	|	ТаблицаИзменений.Назначение КАК Назначение,
	|	ТаблицаИзменений.Серия КАК Серия,
	|	ТаблицаИзменений.Распоряжение КАК Распоряжение,
	|	СУММА(ТаблицаИзменений.КОтборуИзменение) КАК КОтборуИзменение,
	|	СУММА(ТаблицаИзменений.ОтбираетсяИзменение) КАК ОтбираетсяИзменение,
	|	СУММА(ТаблицаИзменений.ОтобраноИзменение) КАК ОтобраноИзменение
	|ПОМЕСТИТЬ ДвиженияТоварыКОтборуИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		Таблица.Номенклатура КАК Номенклатура,
	|		Таблица.Характеристика КАК Характеристика,
	|		Таблица.Назначение КАК Назначение,
	|		Таблица.Серия КАК Серия,
	|		Таблица.Распоряжение КАК Распоряжение,
	|		Таблица.КОтборуПередЗаписью КАК КОтборуИзменение,
	|		Таблица.ОтбираетсяПередЗаписью КАК ОтбираетсяИзменение,
	|		Таблица.ОтобраноПередЗаписью КАК ОтобраноИзменение
	|	ИЗ
	|		ДвиженияТоварыКОтборуПередЗаписью КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Таблица.Номенклатура,
	|		Таблица.Характеристика,
	|		Таблица.Назначение,
	|		Таблица.Серия,
	|		Таблица.Распоряжение,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.КОтбору
	|			ИНАЧЕ Таблица.КОтбору
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Отбирается
	|			ИНАЧЕ Таблица.Отбирается
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -Таблица.Отобрано
	|			ИНАЧЕ Таблица.Отобрано
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ТоварыКОтбору КАК Таблица
	|	ГДЕ
	|		Таблица.Регистратор = &Регистратор 
	|		И Таблица.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)) КАК ТаблицаИзменений
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаИзменений.Номенклатура,
	|	ТаблицаИзменений.Распоряжение,
	|	ТаблицаИзменений.Характеристика,
	|	ТаблицаИзменений.Назначение,
	|	ТаблицаИзменений.Серия
	|
	|ИМЕЮЩИЕ
	// По КОтбору к не правильному состоянию регистра приведет уменьшение прихода и увеличение расхода.
	|	(СУММА(ТаблицаИзменений.КОтборуИзменение) > 0
	// По Отбирается к не правильному состоянию регистра приведет увеличение прихода и уменьшение расхода.
	|		ИЛИ СУММА(ТаблицаИзменений.ОтбираетсяИзменение)< 0 
	// по Отобрано к не правильному состоянию регистра приведет любое изменение
	|		ИЛИ СУММА(ТаблицаИзменений.ОтобраноИзменение) <> 0) 
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДвиженияТоварыКОтборуПередЗаписью";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет()[0]; // РезультатЗапроса
	Выборка = РезультатЗапроса.Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияТоварыКОтборуИзменение", Выборка.Следующий() И Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли