#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак наличия неиспользуемых движений по себестоимости.
//
//	Возвращаемое значение:
//		Булево - признак наличия неиспользуемых движений по себестоимости.
//
Функция ЕстьНеиспользуемыеДвиженияПоРегистрамСебестоимости() Экспорт
	
	Если НЕ РасчетСебестоимостиПовтИсп.ВозможныНеиспользуемыеДвиженияПоРегистрамСебестоимости() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МенеджерВТ = СформироватьТаблицуНеиспользуемыхДвижений(Истина);
	
	Возврат РасчетСебестоимостиПрикладныеАлгоритмы.РазмерВременнойТаблицы(МенеджерВТ, "ВТНеиспользуемыеДвижения") > 0;
	
КонецФункции

// Возвращает количество регистраторов с неиспользуемыми движениями по себестоимости.
//
//	Возвращаемое значение:
//		Число - количество регистраторов с неиспользуемыми движениями по себестоимости.
//
Функция КоличествоРегистраторовСНеиспользуемымиДвижениями() Экспорт
	
	Если НЕ РасчетСебестоимостиПовтИсп.ВозможныНеиспользуемыеДвиженияПоРегистрамСебестоимости() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СформироватьТаблицуНеиспользуемыхДвижений(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Т.Регистратор) КАК КоличествоРегистраторов
	|ИЗ
	|	ВТНеиспользуемыеДвижения КАК Т";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.КоличествоРегистраторов;
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьТаблицуНеиспользуемыхДвижений(ТолькоПроверитьНаличие) Экспорт
	
	РегистраторыИсключения = Новый Массив;
	
	Для Каждого МетаРегистратор Из РасчетСебестоимостиПовтИсп.РегистраторыСДвижениямиПриВыключенномУчетеСебестоимости() Цикл
		МетаданныеДокумента = МетаРегистратор.Ключ; // ОбъектМетаданныхДокумент
		РегистраторыИсключения.Добавить(Тип("ДокументСсылка." + МетаданныеДокумента.Имя));
	КонецЦикла;
	
	МассивТекстовЗапроса = Новый Массив;
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	""&ИмяРегистра"" КАК ИмяРегистра,
	|	Т.Регистратор КАК Регистратор,
	|	Т.Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(Т.Период, ДЕНЬ) КАК Период,
	|	&ОчищатьВсеДвижения КАК ОчищатьВсеДвижения
	|	,&ТекстИмяВременнойТаблицы
	|ИЗ
	|	&ИмяРегистра КАК Т
	|ГДЕ
	|	(НЕ &ВестиУчет
	|	И &ТекстОтбораПоПериоду
	|	)
	|	И (&ТекстОтбораПоСлужебнымПолям)";
	
	ПереченьРегистров = РасчетСебестоимостиПовтИсп.РегистрыНеИспользуемыеПриВыключенномУчетеСебестоимости();
	ПереченьНерассчитываемыхРегистров = РасчетСебестоимостиПовтИсп.РегистрыНеРассчитываемыеПриВыключенномУчетеСебестоимости();
	
	Для Каждого КлючИЗначение Из ПереченьНерассчитываемыхРегистров Цикл
		ПереченьРегистров.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ПереченьРегистров Цикл
		
		МетаданныеРегистра 	   = КлючИЗначение.Ключ;
		ЕстьОрганизация 	   = МетаданныеРегистра.Измерения.Найти("Организация") <> Неопределено;
		ЕстьАналитикаПартнеров = МетаданныеРегистра.Измерения.Найти("АналитикаУчетаПоПартнерам") <> Неопределено;
		ПодчиненРегистратору   = НЕ РасчетСебестоимостиУниверсальныеАлгоритмы.ЭтоНезависимыйРегистрСведений(МетаданныеРегистра);
		
		Если ЕстьОрганизация Тогда
			ТекстПоляОрганизации = "Т.Организация";
		ИначеЕсли ЕстьАналитикаПартнеров Тогда 
			ТекстПоляОрганизации = "Т.АналитикаУчетаПоПартнерам.Организация";
		Иначе		
			ТекстПоляОрганизации = "ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
		КонецЕсли;
		
		Если ПодчиненРегистратору Тогда
			ТекстОтбораПоПериоду = "
				|	ИЛИ (Т.Период < &ДатаНачалаУчета
				|		И НЕ ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения))
				|	ИЛИ (Т.Период < ДОБАВИТЬКДАТЕ(&ДатаНачалаУчета, МЕСЯЦ, -1)
				|		И ТИПЗНАЧЕНИЯ(Т.Регистратор) В (&РегистраторыИсключения))";
		Иначе
			ТекстОтбораПоПериоду = "
				|	ИЛИ (Т.Период < ДОБАВИТЬКДАТЕ(&ДатаНачалаУчета, МЕСЯЦ, -1))";
		КонецЕсли;
		
		Если ПереченьНерассчитываемыхРегистров.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			ТекстОтбораПоСлужебнымПолям = "ИСТИНА";
			ТекстОчищатьВсеДвижения = "ИСТИНА";
		Иначе
			ТекстОтбораПоСлужебнымПолям = ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра);
			ТекстОчищатьВсеДвижения = "ЛОЖЬ";
		КонецЕсли;
		
		ТекущийТекстЗапроса = ШаблонЗапроса;
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "ПЕРВЫЕ 1", ?(ТолькоПроверитьНаличие, "ПЕРВЫЕ 1", "РАЗЛИЧНЫЕ"));
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "&ИмяРегистра", МетаданныеРегистра.ПолноеИмя());
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, ",&ТекстИмяВременнойТаблицы", ?(МассивТекстовЗапроса.Количество() = 0, "ПОМЕСТИТЬ ВТНеиспользуемыеДвижения", ""));
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "&ИмяРегистра", МетаданныеРегистра.ПолноеИмя());
		Если НЕ ПодчиненРегистратору Тогда
			ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "Т.Регистратор", "НЕОПРЕДЕЛЕНО");
		КонецЕсли;
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "Т.Организация", ТекстПоляОрганизации);
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "И &ТекстОтбораПоПериоду", ТекстОтбораПоПериоду);
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "&ТекстОтбораПоСлужебнымПолям", ТекстОтбораПоСлужебнымПолям);
		ТекущийТекстЗапроса = СтрЗаменить(ТекущийТекстЗапроса, "&ОчищатьВсеДвижения", ТекстОчищатьВсеДвижения);
		
		МассивТекстовЗапроса.Добавить(ТекущийТекстЗапроса);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС);
	
	Запрос.УстановитьПараметр("ВестиУчет", 		 		ПолучитьФункциональнуюОпцию("ИспользоватьУчетСебестоимости"));
	Запрос.УстановитьПараметр("ДатаНачалаУчета", 		НачалоМесяца(Константы.ДатаНачалаУчетаСебестоимости.Получить()));
	Запрос.УстановитьПараметр("РегистраторыИсключения", РегистраторыИсключения);
	
	Запрос.Выполнить();
	
	Возврат Запрос.МенеджерВременныхТаблиц;
	
КонецФункции

Процедура ОчиститьНеиспользуемыеДвиженияПоРегистрамСебестоимости(Параметры = "", АдресХранилища = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СформироватьТаблицуНеиспользуемыхДвижений(Ложь);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Регистратор			КАК Регистратор,
	|	Т.ИмяРегистра			КАК ИмяРегистра,
	|	Т.Период				КАК Период,
	|	Т.ОчищатьВсеДвижения	КАК ОчищатьВсеДвижения
	|ИЗ
	|	ВТНеиспользуемыеДвижения КАК Т
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	//++ Локализация


	//-- Локализация
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ТекстыЗапросовПоРегистрам = Новый Соответствие;
	
	Пока Выборка.Следующий() Цикл
		
		МетаданныеРегистра   = Метаданные.НайтиПоПолномуИмени(Выборка.ИмяРегистра);
		ПодчиненРегистратору = НЕ РасчетСебестоимостиУниверсальныеАлгоритмы.ЭтоНезависимыйРегистрСведений(МетаданныеРегистра);
		
		Если Метаданные.РегистрыНакопления.Содержит(МетаданныеРегистра) Тогда
			НаборЗаписей = РегистрыНакопления[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
		Иначе
			НаборЗаписей = РегистрыСведений[МетаданныеРегистра.Имя].СоздатьНаборЗаписей();
		КонецЕсли;
		
		Если ПодчиненРегистратору Тогда
			ЭлементОтбора = НаборЗаписей.Отбор.Регистратор; // ЭлементОтбора
			ЭлементОтбора.Установить(Выборка.Регистратор);
		Иначе
			ЭлементОтбора = НаборЗаписей.Отбор.Период; // ЭлементОтбора
			ЭлементОтбора.Установить(Выборка.Период);
		КонецЕсли;
		
		Если НЕ Выборка.ОчищатьВсеДвижения Тогда
			
			ТекстЗапроса = ТекстыЗапросовПоРегистрам.Получить(Выборка.ИмяРегистра);
			
			Если НЕ ЗначениеЗаполнено(ТекстЗапроса) Тогда
				
				ТекстЗапроса =
				"ВЫБРАТЬ
				|	*
				|ИЗ
				|	&ИмяРегистра КАК Т
				|ГДЕ
				|	&ТекстОтбораПоИзмерениям
				|	И НЕ (&ТекстОтбораПоСлужебнымПолям)";
				
				ТекстОтбораПоСлужебнымПолям = ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра);
				
				Если ПодчиненРегистратору Тогда
					ТекстОтбораПоИзмерениям = "Т.Регистратор = &Регистратор";
				Иначе
					ТекстОтбораПоИзмерениям = "Т.Период = &Период";
				КонецЕсли;
				
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяРегистра", Выборка.ИмяРегистра);
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстОтбораПоИзмерениям", ТекстОтбораПоИзмерениям);
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстОтбораПоСлужебнымПолям", ТекстОтбораПоСлужебнымПолям);
				
				ТекстыЗапросовПоРегистрам.Вставить(Выборка.ИмяРегистра, ТекстЗапроса);
				
			КонецЕсли;
			
			Запрос.Текст = ТекстЗапроса;
			
			Если ПодчиненРегистратору Тогда
				Запрос.УстановитьПараметр("Регистратор", Выборка.Регистратор);
			Иначе
				Запрос.УстановитьПараметр("Период", 	 Выборка.Период);
			КонецЕсли;
			
			НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
			
		КонецЕсли;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	ДатаНачалаУчета = НачалоМесяца(Константы.ДатаНачалаУчетаСебестоимости.Получить());
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.ОчиститьЗаписиЗаПериод(, ДатаНачалаУчета - 1);
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(НачалоМесяца(ДатаНачалаУчета - 1));
	
КонецПроцедуры 

Функция ТекстОтбораПоСлужебнымПолям(МетаданныеРегистра)
	
	ЕстьРасчетПартий 		= (МетаданныеРегистра.Реквизиты.Найти("РасчетПартий") <> Неопределено);
	ЕстьРасчетСебестоимости = (МетаданныеРегистра.Реквизиты.Найти("РасчетСебестоимости") <> Неопределено);
	
	Если ЕстьРасчетПартий И ЕстьРасчетСебестоимости Тогда
		ТекстОтбора = "Т.РасчетПартий ИЛИ Т.РасчетСебестоимости";
	ИначеЕсли ЕстьРасчетПартий Тогда
		ТекстОтбора = "Т.РасчетПартий";
	ИначеЕсли ЕстьРасчетСебестоимости Тогда
		ТекстОтбора = "Т.РасчетСебестоимости";
	Иначе
		ТекстОтбора = "ЛОЖЬ";
	КонецЕсли;
	
	Возврат ТекстОтбора;
	
КонецФункции

//++ Локализация


//-- Локализация

#КонецОбласти

#КонецЕсли
