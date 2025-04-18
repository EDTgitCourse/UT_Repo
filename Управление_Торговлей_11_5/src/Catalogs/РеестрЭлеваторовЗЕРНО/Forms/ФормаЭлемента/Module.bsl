#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМестаХранения

&НаКлиенте
Процедура МестаХраненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Объект.МестаХранения.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если Поле = Элементы.МестаХраненияМестоХранения Тогда
		ПоказатьЗначение(, ДанныеСтроки.МестоХранения);
	ИначеЕсли Поле = Элементы.МестаХраненияТипЗернохранилища Тогда
		ПоказатьЗначение(, ДанныеСтроки.ТипЗернохранилища);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Элементы.Наименование.ТолькоПросмотр    = Истина;
		Элементы.ТипОрганизации.ТолькоПросмотр  = Истина;
		Элементы.ИНН.ТолькоПросмотр             = Истина;
		Элементы.КПП.ТолькоПросмотр             = Истина;
		Элементы.ОГРН.ТолькоПросмотр            = Истина;
		Элементы.Идентификатор.ТолькоПросмотр   = Истина;
	КонецЕсли;
	
	Элементы.ИНН.Видимость      = Ложь;
	Элементы.КПП.Видимость      = Ложь;
	Элементы.ОГРН.Видимость     = Ложь;
	
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ЮридическоеЛицо") Тогда
		Элементы.ИНН.Видимость  = Истина;
		Элементы.КПП.Видимость  = Истина;
		Элементы.ОГРН.Видимость = Истина;
	ИначеЕсли Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ИндивидуальныйПредприниматель") Тогда
		Элементы.ИНН.Видимость      = Истина;
		Элементы.ОГРН.Видимость     = Истина;
	ИначеЕсли Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.Самозанятый") Тогда
		Элементы.ИНН.Видимость      = Истина;
	ИначеЕсли Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизацийЗЕРНО.ИностраннаяОрганизация") Тогда
		Элементы.ИНН.Видимость  = Истина;
		Элементы.КПП.Видимость  = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
