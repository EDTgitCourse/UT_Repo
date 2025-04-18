
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СформироватьЗаголовокРеквизиты();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьЗаголовокРеквизиты()
	
	ТекстЗаголовок = "";
	МассивСтрок = Новый Массив;
	
	Для Каждого Строка Из Параметры.ПараметрыЗапретаРедактированияРеквизитов Цикл
		
		Если Не Строка.ПравоРедактирования Тогда 
			Продолжить;
		КонецЕсли;
		
		Если НЕ ТекстЗаголовок = "" И СтрДлина(ТекстЗаголовок + ", " + Строка.Представление) > 75 Тогда 
			МассивСтрок.Добавить(ТекстЗаголовок + ",");
			ТекстЗаголовок = Строка.Представление;
		Иначе 
			ТекстЗаголовок = ТекстЗаголовок + ?(ТекстЗаголовок = "", "", ", ") + Строка.Представление;
		КонецЕсли;
		
	КонецЦикла;
	
	МассивСтрок.Добавить(ТекстЗаголовок);
	Элементы.ЗаголовокРеквизиты.Заголовок = СтрСоединить(МассивСтрок, Символы.ПС);
	
КонецПроцедуры

#КонецОбласти
