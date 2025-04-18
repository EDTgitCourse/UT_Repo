
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Организация", Параметры.Организация);
	Список.Параметры.УстановитьЗначениеПараметра("ДатаПроверки", Параметры.Период);
	Список.Параметры.УстановитьЗначениеПараметра("ОбиратьВсеПатенты", НЕ ЗначениеЗаполнено(Параметры.Период));
	
	СписокПодразделений = Новый Массив();
	НетФильтраПоПодразделениям = Истина;
	
	Если ЗначениеЗаполнено(Параметры.Подразделение) Тогда
		
		ВышестоящееПодразделение = Параметры.Подразделение;
			
			Пока ЗначениеЗаполнено(ВышестоящееПодразделение) Цикл
				СписокПодразделений.Добавить(ВышестоящееПодразделение);
				ВышестоящееПодразделение = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВышестоящееПодразделение, "Родитель");
			КонецЦикла;
			
		НетФильтраПоПодразделениям = Ложь;
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("СписокПодразделений", СписокПодразделений);
	Список.Параметры.УстановитьЗначениеПараметра("НетФильтраПоПодразделениям", НетФильтраПоПодразделениям);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
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

#КонецОбласти