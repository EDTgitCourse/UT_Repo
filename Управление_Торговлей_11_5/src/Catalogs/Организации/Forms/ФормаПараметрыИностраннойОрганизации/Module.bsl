
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВидОрганизации = Параметры.ВидОрганизации;
	ОтделениеИностраннойОрганизации = Параметры.ОтделениеИностраннойОрганизации;
	ЗарегистрированВОЭЗ = Параметры.ЗарегистрированВОЭЗ;
	НаименованиеИнострОрганизации = Параметры.НаименованиеИнострОрганизации;
	КодВСтранеРегистрации = Параметры.КодВСтранеРегистрации;
	НаименованиеИдентификатораВСтранеРегистрации =  Параметры.НаименованиеИдентификатораВСтранеРегистрации;
	СтранаПостоянногоМестонахождения = Параметры.СтранаПостоянногоМестонахождения;
	СтранаРегистрацииИностраннойОрганизации = Параметры.СтранаРегистрацииИностраннойОрганизации;
	
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("СохранитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИностраннаяОрганизацияПриИзменении(Элемент)
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда) 
	
	СохранитьИЗакрыть();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	Форма.Элементы.ГруппаИспользуетсяИностраннаяОрганизация.Доступность = Форма.ОтделениеИностраннойОрганизации;
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть() Экспорт
	
	Модифицированность = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОтделениеИностраннойОрганизации", ОтделениеИностраннойОрганизации);
	СтруктураПараметров.Вставить("ЗарегистрированВОЭЗ", ЗарегистрированВОЭЗ);
	СтруктураПараметров.Вставить("КодВСтранеРегистрации", КодВСтранеРегистрации);
	СтруктураПараметров.Вставить("НаименованиеИдентификатораВСтранеРегистрации", НаименованиеИдентификатораВСтранеРегистрации);
	СтруктураПараметров.Вставить("СтранаПостоянногоМестонахождения", СтранаПостоянногоМестонахождения);
	СтруктураПараметров.Вставить("НаименованиеИнострОрганизации", НаименованиеИнострОрганизации);
	СтруктураПараметров.Вставить("СтранаРегистрацииИностраннойОрганизации", СтранаРегистрацииИностраннойОрганизации);
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры

#КонецОбласти
