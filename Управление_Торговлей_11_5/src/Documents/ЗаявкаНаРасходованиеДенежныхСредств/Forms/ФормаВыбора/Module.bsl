
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("Отбор")
	   И Параметры.Отбор.Свойство("Получатель")
	   И Не ЗначениеЗаполнено(Параметры.Отбор.Получатель) Тогда
		Параметры.Отбор.Удалить("Получатель");
	КонецЕсли;
	
	БезОтбора = Ложь;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Параметры, "ТолькоОстатки") Тогда
		ТолькоОстатки = Параметры.ТолькоОстатки;
	Иначе
		БезОтбора = Истина;
	КонецЕсли;
	
	Элементы.ТолькоОстатки.Видимость = Не БезОтбора;
	
	Если Не БезОтбора Тогда
		
		ЗаполнитьПараметрыОтбора();
		ОграничитьСписокЗаявок();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоОстаткиПриИзменении(Элемент)
	
	ТолькоОстаткиПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТолькоОстаткиПриИзмененииНаСервере()

	ОграничитьСписокЗаявок();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыОтбора()

	ПараметрыОтбора = НовыйПараметрыОтбораЗаявок();
	
	Для Каждого ЭлементОтбора Из Параметры.Отбор Цикл
		
		Если ПараметрыОтбора.Свойство(ЭлементОтбора.Ключ)
			И ЗначениеЗаполнено(Параметры.Отбор[ЭлементОтбора.Ключ]) Тогда
			ПараметрыОтбора.Вставить(ЭлементОтбора.Ключ, Параметры.Отбор[ЭлементОтбора.Ключ]);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЭлементПараметра Из ПараметрыОтбора Цикл
		
		Если Параметры.Свойство(ЭлементПараметра.Ключ)
			И ЗначениеЗаполнено(Параметры[ЭлементПараметра.Ключ]) Тогда
			ПараметрыОтбора.Вставить(ЭлементПараметра.Ключ, Параметры[ЭлементПараметра.Ключ]);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Параметры.Отбор.Свойство("ХозяйственнаяОперацияПоЗарплате") Тогда
		ПараметрыОтбора.Вставить("ХозяйственнаяОперация", Параметры.Отбор.ХозяйственнаяОперацияПоЗарплате);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОграничитьСписокЗаявок()

	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "Документ.ЗаявкаНаРасходованиеДенежныхСредств";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаСОтбором();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	Получатель = ДенежныеСредстваСервер.ПолучательПлатежа(ПараметрыОтбора);
	
	Список.Параметры.УстановитьЗначениеПараметра("Валюта", ПараметрыОтбора.Валюта);
	Список.Параметры.УстановитьЗначениеПараметра("Организация", ПараметрыОтбора.Организация);
	Список.Параметры.УстановитьЗначениеПараметра("ОперацияССамозанятым", ПараметрыОтбора.ОперацияССамозанятым);
	Список.Параметры.УстановитьЗначениеПараметра("ФормаОплаты", ПараметрыОтбора.ФормаОплаты);
	Список.Параметры.УстановитьЗначениеПараметра("ХозяйственнаяОперация", ПараметрыОтбора.ХозяйственнаяОперация);
	Список.Параметры.УстановитьЗначениеПараметра("БанковскийСчетКасса", ПараметрыОтбора.БанковскийСчетКасса);
	Список.Параметры.УстановитьЗначениеПараметра("Получатель", Получатель);

КонецПроцедуры

&НаСервере
Функция НовыйПараметрыОтбораЗаявок()

	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	Отбор.Вставить("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
	Отбор.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПустаяСсылка());
	Отбор.Вставить("ПодотчетноеЛицо", Неопределено);
	Отбор.Вставить("ФормаОплаты", Перечисления.ФормыОплаты.ПустаяСсылка());
	Отбор.Вставить("Валюта", Справочники.Валюты.ПустаяСсылка());
	Отбор.Вставить("БанковскийСчетКасса", Неопределено);
	Отбор.Вставить("БанковскийСчетПолучатель", Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка());
	Отбор.Вставить("КассаПолучатель", Справочники.Кассы.ПустаяСсылка());
	Отбор.Вставить("СписокКонтрагентов", Ложь);
	Отбор.Вставить("ОперацияССамозанятым", Неопределено);
	
	Возврат Отбор;

КонецФункции

&НаСервере
Функция ТекстЗапросаСОтбором()

	ТекстыЗапросов = Новый Массив;
	ТекстыЗапросов.Добавить(ТекстВыборкиЗаявокСОтбором());
	
	Если ТолькоОстатки Тогда
		ТекстыЗапросов.Добавить(ТекстВыборкиНеоплаченныхЗаявокСОтбором());
	КонецЕсли;
	
	ИтоговаяВыборка = 
		"ВЫБРАТЬ
		|	ЗаявкиНаРасходование.Ссылка КАК Ссылка,
		|	ЗаявкиНаРасходование.ПометкаУдаления КАК ПометкаУдаления,
		|	ЗаявкиНаРасходование.Номер КАК Номер,
		|	ЗаявкиНаРасходование.Дата КАК Дата,
		|	ЗаявкиНаРасходование.Проведен КАК Проведен,
		|	ЗаявкиНаРасходование.Организация КАК Организация,
		|	ЗаявкиНаРасходование.Статус КАК Статус,
		|	ЗаявкиНаРасходование.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ЗаявкиНаРасходование.ХозяйственнаяОперацияПоЗарплате КАК ХозяйственнаяОперацияПоЗарплате,
		|	ЗаявкиНаРасходование.СуммаДокумента КАК СуммаДокумента,
		|	ЗаявкиНаРасходование.Валюта КАК Валюта,
		|	ЗаявкиНаРасходование.ДатаПлатежа КАК ДатаПлатежа,
		|	ЗаявкиНаРасходование.Контрагент КАК Контрагент,
		|	ЗаявкиНаРасходование.Подразделение КАК Подразделение,
		|	ЗаявкиНаРасходование.КтоЗаявил КАК КтоЗаявил,
		|	ЗаявкиНаРасходование.ПриоритетОплаты КАК ПриоритетОплаты
		|ИЗ
		|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкиНаРасходование
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ &ЗаменяемаяТаблица КАК ИтоговаяТаблица
		|		ПО ЗаявкиНаРасходование.Ссылка = ИтоговаяТаблица.Ссылка
		|";
	
	Если ТолькоОстатки Тогда
		ИтоговаяВыборка = СтрЗаменить(ИтоговаяВыборка, "&ЗаменяемаяТаблица", "НеоплаченныеЗаявки");
	Иначе
		ИтоговаяВыборка = СтрЗаменить(ИтоговаяВыборка, "&ЗаменяемаяТаблица", "Заявки");
	КонецЕсли;
	
	ТекстыЗапросов.Добавить(ИтоговаяВыборка);
	
	Возврат СтрСоединить(ТекстыЗапросов, ";");

КонецФункции

&НаСервере
Функция ТекстВыборкиЗаявокСОтбором()

	Возврат 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	Заявка.Ссылка КАК Ссылка,
	|	Заявка.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Заявка.ХозяйственнаяОперацияПоЗарплате КАК ХозяйственнаяОперацияПоЗарплате,
	|	Заявка.Контрагент КАК Контрагент,
	|	Заявка.ПодотчетноеЛицо КАК ПодотчетноеЛицо,
	|	Заявка.ОрганизацияПолучатель КАК ОрганизацияПолучатель,
	|	Заявка.СписокФизЛиц КАК СписокФизЛиц,
	|	Заявка.СписокКонтрагентов КАК СписокКонтрагентов
	|ПОМЕСТИТЬ ЗаявкиСОтбором
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Заявка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаРасходованиеДенежныхСредств.РаспределениеПоСчетам КАК ЗаявкаРаспределениеПоСчетам
	|		ПО Заявка.Ссылка = ЗаявкаРаспределениеПоСчетам.Ссылка
	|ГДЕ
	|	(Заявка.ФормаОплатыЗаявки = &ФормаОплаты
	|			ИЛИ Заявка.ФормаОплатыЗаявки = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.ПустаяСсылка))
	|	И (Заявка.Валюта = &Валюта
	|			ИЛИ Заявка.ПланированиеСуммы = ЗНАЧЕНИЕ(Перечисление.СпособыПланированияОплатыЗаявок.ВВалютеВзаиморасчетов))
	|	И Заявка.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате)
	|	И (Заявка.ОперацияССамозанятым = &ОперацияССамозанятым
	|			ИЛИ &ОперацияССамозанятым = НЕОПРЕДЕЛЕНО)
	|	И Заявка.Организация = &Организация
	|	И (ЗаявкаРаспределениеПоСчетам.БанковскийСчетКасса = &БанковскийСчетКасса
	|			ИЛИ ЗаявкаРаспределениеПоСчетам.БанковскийСчетКасса ЕСТЬ NULL)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Заявки.Ссылка КАК Ссылка,
	|	Заявки.Контрагент КАК Контрагент,
	|	Заявки.ПодотчетноеЛицо КАК ПодотчетноеЛицо,
	|	Заявки.ОрганизацияПолучатель КАК ОрганизацияПолучатель,
	|	Заявки.СписокФизЛиц КАК СписокФизЛиц,
	|	Заявки.СписокКонтрагентов КАК СписокКонтрагентов
	|ПОМЕСТИТЬ ЗаявкиВыбраннойОперации
	|ИЗ
	|	ЗаявкиСОтбором КАК Заявки
	|ГДЕ
	|	Заявки.ХозяйственнаяОперация = &ХозяйственнаяОперация
	|	И Заявки.ХозяйственнаяОперацияПоЗарплате <> &ХозяйственнаяОперация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Заявки.Ссылка,
	|	Заявки.Контрагент,
	|	Заявки.ПодотчетноеЛицо,
	|	Заявки.ОрганизацияПолучатель,
	|	Заявки.СписокФизЛиц,
	|	Заявки.СписокКонтрагентов
	|ИЗ
	|	ЗаявкиСОтбором КАК Заявки
	|ГДЕ
	|	Заявки.ХозяйственнаяОперацияПоЗарплате В(&ХозяйственнаяОперация)
	|	И НЕ Заявки.ХозяйственнаяОперация В (&ХозяйственнаяОперация)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкиВыбраннойОперации.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Заявки
	|ИЗ
	|	ЗаявкиВыбраннойОперации КАК ЗаявкиВыбраннойОперации
	|ГДЕ
	|	ЗаявкиВыбраннойОперации.Контрагент В(&Получатель)
	|	И НЕ ЗаявкиВыбраннойОперации.СписокКонтрагентов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявкиВыбраннойОперации.Ссылка
	|ИЗ
	|	ЗаявкиВыбраннойОперации КАК ЗаявкиВыбраннойОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК РасшифровкаПлатежа
	|		ПО ЗаявкиВыбраннойОперации.Ссылка = РасшифровкаПлатежа.Ссылка
	|ГДЕ
	|	РасшифровкаПлатежа.Контрагент В(&Получатель)
	|	И ЗаявкиВыбраннойОперации.СписокКонтрагентов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаявкиВыбраннойОперации.Ссылка
	|ИЗ
	|	ЗаявкиВыбраннойОперации КАК ЗаявкиВыбраннойОперации
	|ГДЕ
	|	ЗаявкиВыбраннойОперации.ПодотчетноеЛицо В(&Получатель)
	|	И НЕ ЗаявкиВыбраннойОперации.СписокФизЛиц
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявкиВыбраннойОперации.Ссылка
	|ИЗ
	|	ЗаявкиВыбраннойОперации КАК ЗаявкиВыбраннойОперации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаРасходованиеДенежныхСредств.ЛицевыеСчетаСотрудников КАК ЛицевыеСчетаСотрудников
	|		ПО ЗаявкиВыбраннойОперации.Ссылка = ЛицевыеСчетаСотрудников.Ссылка
	|ГДЕ
	|	ЛицевыеСчетаСотрудников.ФизическоеЛицо В(&Получатель)
	|	И ЗаявкиВыбраннойОперации.СписокФизЛиц
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗаявкиВыбраннойОперации.Ссылка
	|ИЗ
	|	ЗаявкиВыбраннойОперации КАК ЗаявкиВыбраннойОперации
	|ГДЕ
	|	ЗаявкиВыбраннойОперации.ОрганизацияПолучатель В(&Получатель)
	|";

КонецФункции

&НаСервере
Функция ТекстВыборкиНеоплаченныхЗаявокСОтбором()

	Возврат 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДенежныеСредства.ЗаявкаНаРасходованиеДенежныхСредств КАК Ссылка
		|ПОМЕСТИТЬ НеоплаченныеЗаявки
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваКВыплате.Остатки(
		|			,
		|			ЗаявкаНаРасходованиеДенежныхСредств В
		|				(ВЫБРАТЬ
		|					Заявки.Ссылка
		|				ИЗ
		|					Заявки КАК Заявки)) КАК ДенежныеСредства
		|";

КонецФункции

#КонецОбласти
