#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ОтборПоТипамОпераций")
		Или Параметры.ОтборПоТипамОпераций.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПараметрыОтбора(Параметры);
	
	Если Параметры.ОтборПоТипамОпераций.Количество() = 1 Тогда
		
		ХозяйственнаяОперация = Параметры.ОтборПоТипамОпераций.Получить(0).Значение;
		
		Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
			ПодготовитьПараметрыОткрытияФормыДокумента(ХозяйственнаяОперация);
		Иначе
			Возврат;
		КонецЕсли;
		
	Иначе
		СписокВидовОпераций.ЗагрузитьЗначения(Параметры.ОтборПоТипамОпераций.ВыгрузитьЗначения());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	//ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ЗначениеЗаполнено(ПараметрыОткрытияФормыДокумента) Тогда
		ОткрытьДокументВводаОстатков();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовОперацийЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТиповОпераций

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ХозяйственнаяОперация = Элемент.ТекущиеДанные.Значение;
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда 
		ОбработкаВыбораХозяйственнойОперации(ХозяйственнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьТипОперации(Команда)
	
	ХозяйственнаяОперация = Элементы.СписокВидовОпераций.ТекущиеДанные.Значение;
	
	Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		ОбработкаВыбораХозяйственнойОперации(ХозяйственнаяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораХозяйственнойОперации(ХозяйственнаяОперация)
	ПодготовитьПараметрыОткрытияФормыДокумента(ХозяйственнаяОперация);
	ОткрытьДокументВводаОстатков();
КонецПроцедуры

&НаСервере
Функция ОпределитьДокументПоХозяйственнойОперации(ХозяйственнаяОперация)
	
	ТипДокументаВводаНачальныхОстатков = ВводОстатковСервер.ОпределитьДокументПоХозяйственнойОперации(ХозяйственнаяОперация);
	Возврат ТипДокументаВводаНачальныхОстатков;
	
КонецФункции

&НаСервере
Процедура ПодготовитьПараметрыОткрытияФормыДокумента(ХозяйственнаяОперация)
	
	ТипДокументаВводаНачальныхОстатков = ОпределитьДокументПоХозяйственнойОперации(ХозяйственнаяОперация);
	ИмяДокументаВводаОстатков          = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТипДокументаВводаНачальныхОстатков, "Имя");
	ИмяФормыДокумента                  = СтрШаблон("Документ.%1.ФормаОбъекта", ИмяДокументаВводаОстатков);
	ЗначенияЗаполнения                 = ВводОстатковСервер.ИнициализироватьЗначенияЗаполненияДокументаВводОстатков();
	
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, ПараметрыЗаполнения);
	ЗначенияЗаполнения.ХозяйственнаяОперация = ХозяйственнаяОперация;
	
	ПараметрыОткрытияФормыДокумента = Новый Структура();
	ПараметрыОткрытияФормыДокумента.Вставить("ИмяФормыДокумента",                 ИмяФормыДокумента);
	ПараметрыОткрытияФормыДокумента.Вставить("ПараметрыФормы",                    Новый Структура());
	ПараметрыОткрытияФормыДокумента.ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВводаОстатков()
	
	Модифицированность = Ложь;
	
	ОткрытьФорму(ПараметрыОткрытияФормыДокумента.ИмяФормыДокумента, ПараметрыОткрытияФормыДокумента.ПараметрыФормы, ВладелецФормы, );
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыОтбора(Параметры)
	ПараметрыЗаполнения = ВводОстатковСервер.ИнициализироватьЗначенияЗаполненияДокументаВводОстатков();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, Параметры.ПараметрыЗаполнения);
КонецПроцедуры

#КонецОбласти
