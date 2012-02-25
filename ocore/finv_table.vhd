library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity finv_table is
  port (
		clka : in std_logic;
		addra : in std_logic_vector(9 downto 0);
		douta : out std_logic_vector(35 downto 0) := (others=>'0'));
end finv_table;

architecture op of finv_table is

	subtype table_rec_t is std_logic_vector(35 downto 0);
	type table_t is array (0 to 1023) of table_rec_t;
	signal addr_in	: integer range 0 to 1023;

	constant table : table_t := (
x"FFFFFBFF8",
x"FF801BFE8",
x"FF007BFD8",
x"FE811BFC8",
x"FE01F9FB8",
x"FD8319FA9",
x"FD0475F99",
x"FC8611F89",
x"FC07EDF7A",
x"FB8A05F6A",
x"FB0C5DF5B",
x"FA8EF1F4B",
x"FA11C7F3C",
x"F994D7F2C",
x"F91827F1D",
x"F89BB5F0E",
x"F81F7DEFE",
x"F7A383EEF",
x"F727C9EE0",
x"F6AC49ED1",
x"F63107EC2",
x"F5B601EB3",
x"F53B37EA4",
x"F4C0A9E95",
x"F44657E86",
x"F3CC3FE77",
x"F35263E68",
x"F2D8C3E59",
x"F25F5FE4A",
x"F1E637E3C",
x"F16D47E2D",
x"F0F493E1E",
x"F07C1BE10",
x"F003DBE01",
x"EF8BD7DF3",
x"EF140BDE4",
x"EE9C7BDD6",
x"EE2523DC7",
x"EDAE05DB9",
x"ED3723DAB",
x"ECC079D9D",
x"EC4A05D8E",
x"EBD3CBD80",
x"EB5DCBD72",
x"EAE803D64",
x"EA7273D56",
x"E9FD1DD48",
x"E987FDD3A",
x"E91317D2C",
x"E89E67D1E",
x"E829EFD10",
x"E7B5AFD02",
x"E741A5CF4",
x"E6CDD5CE7",
x"E65A39CD9",
x"E5E6D5CCB",
x"E573A9CBE",
x"E500B1CB0",
x"E48DF3CA3",
x"E41B67C95",
x"E3A913C87",
x"E336F5C7A",
x"E2C50DC6D",
x"E25359C5F",
x"E1E1DDC52",
x"E17097C45",
x"E0FF83C37",
x"E08EA5C2A",
x"E01DFDC1D",
x"DFAD8BC10",
x"DF3D4BC03",
x"DECD41BF6",
x"DE5D6BBE9",
x"DDEDC9BDC",
x"DD7E5BBCF",
x"DD0F21BC2",
x"DCA01BBB5",
x"DC3147BA8",
x"DBC2A7B9B",
x"DB543BB8E",
x"DAE603B81",
x"DA77FFB75",
x"DA0A2BB68",
x"D99C8BB5B",
x"D92F1FB4F",
x"D8C1E3B42",
x"D854DDB36",
x"D7E805B29",
x"D77B61B1C",
x"D70EEFB10",
x"D6A2AFB04",
x"D636A1AF7",
x"D5CAC5AEB",
x"D55F19ADF",
x"D4F39FAD2",
x"D48855AC6",
x"D41D3FABA",
x"D3B257AAE",
x"D3479FAA1",
x"D2DD1BA95",
x"D272C5A89",
x"D208A1A7D",
x"D19EADA71",
x"D134E9A65",
x"D0CB55A59",
x"D061F1A4D",
x"CFF8BBA41",
x"CF8FB7A35",
x"CF26E3A2A",
x"CEBE3DA1E",
x"CE55C5A12",
x"CDED7DA06",
x"CD85639FA",
x"CD1D7B9EF",
x"CCB5BF9E3",
x"CC4E339D7",
x"CBE6D59CC",
x"CB7FA59C0",
x"CB18A59B5",
x"CAB1D19A9",
x"CA4B2D99E",
x"C9E4B5992",
x"C97E6D987",
x"C9185197C",
x"C8B261970",
x"C84CA1965",
x"C7E70F95A",
x"C781A794E",
x"C71C6D943",
x"C6B761938",
x"C6528392D",
x"C5EDD1922",
x"C58949916",
x"C524EF90B",
x"C4C0C1900",
x"C45CC18F5",
x"C3F8ED8EA",
x"C395438DF",
x"C331C78D4",
x"C2CE758C9",
x"C26B4F8BE",
x"C208578B4",
x"C1A5898A9",
x"C142E589E",
x"C0E06D893",
x"C07E1F888",
x"C01BFF87E",
x"BFBA07873",
x"BF583B868",
x"BEF69B85E",
x"BE9523853",
x"BE33D7848",
x"BDD2B583E",
x"BD71BD833",
x"BD10F1829",
x"BCB04B81E",
x"BC4FD3814",
x"BBEF8580A",
x"BB8F5D7FF",
x"BB2F617F5",
x"BACF8D7EA",
x"BA6FE57E0",
x"BA10657D6",
x"B9B10D7CB",
x"B951DF7C1",
x"B8F2DB7B7",
x"B893FF7AD",
x"B8354B7A3",
x"B7D6C1799",
x"B7785D78E",
x"B71A25784",
x"B6BC1377A",
x"B65E2B770",
x"B60069766",
x"B5A2D175C",
x"B54561752",
x"B4E817748",
x"B48AF773E",
x"B42DFD734",
x"B3D12D72B",
x"B37481721",
x"B317FF717",
x"B2BBA370D",
x"B25F6D703",
x"B203616FA",
x"B1A77B6F0",
x"B14BBB6E6",
x"B0F0236DD",
x"B094B16D3",
x"B039636C9",
x"AFDE416C0",
x"AF83416B6",
x"AF28696AD",
x"AECDB76A3",
x"AE7329699",
x"AE18C5690",
x"ADBE85687",
x"AD646B67D",
x"AD0A77674",
x"ACB0A766A",
x"AC56FF661",
x"ABFD7B658",
x"ABA41D64E",
x"AB4AE3645",
x"AAF1D163C",
x"AA98E1632",
x"AA4017629",
x"A9E773620",
x"A98EF3617",
x"A9369960E",
x"A8DE61604",
x"A8864F5FB",
x"A82E615F2",
x"A7D6995E9",
x"A77EF55E0",
x"A727735D7",
x"A6D0175CE",
x"A678DF5C5",
x"A621CB5BC",
x"A5CAD95B3",
x"A5740D5AA",
x"A51D635A1",
x"A4C6DF598",
x"A4707D590",
x"A41A3F587",
x"A3C42357E",
x"A36E2B575",
x"A3185756C",
x"A2C2A7564",
x"A26D1755B",
x"A217AB552",
x"A1C261549",
x"A16D3D541",
x"A11839538",
x"A0C359530",
x"A06E9B527",
x"A019FF51E",
x"9FC585516",
x"9F712D50D",
x"9F1CF9505",
x"9EC8E74FC",
x"9E74F74F4",
x"9E21274EB",
x"9DCD7B4E3",
x"9D79ED4DA",
x"9D26854D2",
x"9CD33F4CA",
x"9C80174C1",
x"9C2D134B9",
x"9BDA2F4B1",
x"9B876D4A8",
x"9B34CB4A0",
x"9AE24D498",
x"9A8FED48F",
x"9A3DAF487",
x"99EB9347F",
x"999997477",
x"9947BD46F",
x"98F601466",
x"98A46745E",
x"9852ED456",
x"98019544E",
x"97B05D446",
x"975F4543E",
x"970E4D436",
x"96BD7542E",
x"966CBD426",
x"961C2541E",
x"95CBAF416",
x"957B5740E",
x"952B1F406",
x"94DB053FE",
x"948B0D3F6",
x"943B333EE",
x"93EB7B3E7",
x"939BE13DF",
x"934C653D7",
x"92FD093CF",
x"92ADCD3C7",
x"925EB13C0",
x"920FB33B8",
x"91C0D33B0",
x"9172113A8",
x"9123713A1",
x"90D4EF399",
x"90868B391",
x"90384738A",
x"8FEA1F382",
x"8F9C1537A",
x"8F4E2D373",
x"8F006136B",
x"8EB2B5364",
x"8E652535C",
x"8E17B5355",
x"8DCA6134D",
x"8D7D2D346",
x"8D301533E",
x"8CE31D337",
x"8C964132F",
x"8C4985328",
x"8BFCE7321",
x"8BB063319",
x"8B63FF312",
x"8B17B730A",
x"8ACB8F303",
x"8A7F832FC",
x"8A33932F4",
x"89E7C12ED",
x"899C0D2E6",
x"8950772DF",
x"8904FB2D7",
x"88B99D2D0",
x"886E5D2C9",
x"8823392C2",
x"87D8332BB",
x"878D472B3",
x"8742792AC",
x"86F7C72A5",
x"86AD3329E",
x"8662BB297",
x"86185F290",
x"85CE1F289",
x"8583FD282",
x"8539F527B",
x"84F00B274",
x"84A63B26D",
x"845C89266",
x"8412F125F",
x"83C975258",
x"838017251",
x"8336D324A",
x"82EDA9243",
x"82A49D23C",
x"825BAD235",
x"8212D722E",
x"81CA1F228",
x"81817F221",
x"8138FD21A",
x"80F093213",
x"80A84720C",
x"806017206",
x"8017FF1FF",
x"7FD0031F8",
x"7F88231F1",
x"7F405F1EB",
x"7EF8B31E4",
x"7EB1231DD",
x"7E69AF1D7",
x"7E22531D0",
x"7DDB131C9",
x"7D93ED1C3",
x"7D4CE31BC",
x"7D05F31B6",
x"7CBF1B1AF",
x"7C785F1A8",
x"7C31BF1A2",
x"7BEB3719B",
x"7BA4CB195",
x"7B5E7718E",
x"7B183D188",
x"7AD21D181",
x"7A8C1917B",
x"7A462D174",
x"7A005D16E",
x"79BAA5168",
x"797507161",
x"792F8315B",
x"78EA17154",
x"78A4C714E",
x"785F8F148",
x"781A6F141",
x"77D56B13B",
x"77907F135",
x"774BAB12E",
x"7706F3128",
x"76C253122",
x"767DCB11B",
x"76395D115",
x"75F50910F",
x"75B0CD109",
x"756CAB103",
x"75289F0FC",
x"74E4AD0F6",
x"74A0D50F0",
x"745D150EA",
x"74196F0E4",
x"73D5DF0DE",
x"7392690D8",
x"734F090D1",
x"730BC50CB",
x"72C8970C5",
x"7285830BF",
x"7242850B9",
x"71FFA10B3",
x"71BCD50AD",
x"717A210A7",
x"7137850A1",
x"70F50109B",
x"70B295095",
x"70703F08F",
x"702E03089",
x"6FEBDF083",
x"6FA9D107D",
x"6F67DD077",
x"6F25FF071",
x"6EE43B06C",
x"6EA28B066",
x"6E60F5060",
x"6E1F7505A",
x"6DDE0D054",
x"6D9CBB04E",
x"6D5B83049",
x"6D1A61043",
x"6CD95503D",
x"6C9861037",
x"6C5785031",
x"6C16C102C",
x"6BD611026",
x"6B9579020",
x"6B54F701A",
x"6B148F015",
x"6AD43B00F",
x"6A93FF009",
x"6A53DB004",
x"6A13CAFFE",
x"69D3D2FF8",
x"6993F0FF3",
x"695426FED",
x"691472FE8",
x"68D4D2FE2",
x"68954AFDC",
x"6855DAFD7",
x"68167EFD1",
x"67D73AFCC",
x"67980CFC6",
x"6758F4FC1",
x"6719F0FBB",
x"66DB06FB6",
x"669C2EFB0",
x"665D6EFAB",
x"661EC4FA5",
x"65E030FA0",
x"65A1B0F9A",
x"656348F95",
x"6524F4F8F",
x"64E6B8F8A",
x"64A890F84",
x"646A7EF7F",
x"642C84F7A",
x"63EE9CF74",
x"63B0CAF6F",
x"637310F6A",
x"633568F64",
x"62F7D8F5F",
x"62BA5CF5A",
x"627CF6F54",
x"623FA4F4F",
x"62026AF4A",
x"61C542F44",
x"618830F3F",
x"614B34F3A",
x"610E4CF35",
x"60D178F2F",
x"6094BCF2A",
x"605814F25",
x"601B80F20",
x"5FDF02F1B",
x"5FA296F15",
x"5F6640F10",
x"5F2A00F0B",
x"5EEDD4F06",
x"5EB1BCF01",
x"5E75BAEFC",
x"5E39CCEF7",
x"5DFDF0EF1",
x"5DC22AEEC",
x"5D867AEE7",
x"5D4ADCEE2",
x"5D0F54EDD",
x"5CD3E0ED8",
x"5C9880ED3",
x"5C5D34ECE",
x"5C21FCEC9",
x"5BE6DAEC4",
x"5BABCAEBF",
x"5B70CEEBA",
x"5B35E8EB5",
x"5AFB14EB0",
x"5AC054EAB",
x"5A85A8EA6",
x"5A4B10EA1",
x"5A108CE9C",
x"59D61CE97",
x"599BC0E92",
x"596176E8D",
x"592742E88",
x"58ED22E84",
x"58B314E7F",
x"587918E7A",
x"583F32E75",
x"58055EE70",
x"57CB9EE6B",
x"5791F0E66",
x"575858E62",
x"571ED2E5D",
x"56E55EE58",
x"56ABFEE53",
x"5672B2E4E",
x"56397AE4A",
x"560054E45",
x"55C740E40",
x"558E40E3B",
x"555554E37",
x"551C7AE32",
x"54E3B2E2D",
x"54AAFCE28",
x"54725CE24",
x"5439CEE1F",
x"540150E1A",
x"53C8EAE16",
x"539092E11",
x"53584EE0C",
x"53201EE08",
x"52E7FEE03",
x"52AFF2DFE",
x"5277FADFA",
x"524012DF5",
x"520840DF1",
x"51D07CDEC",
x"5198CCDE7",
x"516130DE3",
x"5129A4DDE",
x"50F22CDDA",
x"50BAC4DD5",
x"508372DD1",
x"504C2EDCC",
x"5014FEDC7",
x"4FDDE2DC3",
x"4FA6D4DBE",
x"4F6FDCDBA",
x"4F38F2DB5",
x"4F021EDB1",
x"4ECB5ADAC",
x"4E94A8DA8",
x"4E5E08DA4",
x"4E277AD9F",
x"4DF0FED9B",
x"4DBA92D96",
x"4D843AD92",
x"4D4DF2D8D",
x"4D17BCD89",
x"4CE19AD85",
x"4CAB86D80",
x"4C7586D7C",
x"4C3F94D77",
x"4C09B8D73",
x"4BD3ECD6F",
x"4B9E30D6A",
x"4B6886D66",
x"4B32F0D62",
x"4AFD66D5D",
x"4AC7F2D59",
x"4A928ED55",
x"4A5D3AD50",
x"4A27F8D4C",
x"49F2C8D48",
x"49BDA8D44",
x"498898D3F",
x"49539CD3B",
x"491EB0D37",
x"48E9D4D33",
x"48B508D2E",
x"488050D2A",
x"484BA8D26",
x"481710D22",
x"47E28AD1E",
x"47AE12D19",
x"4779ACD15",
x"474558D11",
x"471114D0D",
x"46DCE2D09",
x"46A8BED04",
x"4674ACD00",
x"4640AACFC",
x"460CBACF8",
x"45D8DACF4",
x"45A50ACF0",
x"45714CCEC",
x"453D9CCE8",
x"4509FECE4",
x"44D66ECDF",
x"44A2F0CDB",
x"446F84CD7",
x"443C26CD3",
x"4408DACCF",
x"43D59CCCB",
x"43A270CC7",
x"436F54CC3",
x"433C48CBF",
x"43094CCBB",
x"42D660CB7",
x"42A384CB3",
x"4270B8CAF",
x"423DFCCAB",
x"420B50CA7",
x"41D8B4CA3",
x"41A628C9F",
x"4173ACC9B",
x"41413EC97",
x"410EE2C93",
x"40DC94C8F",
x"40AA58C8B",
x"40782AC87",
x"40460EC84",
x"401400C80",
x"3FE202C7C",
x"3FB012C78",
x"3F7E32C74",
x"3F4C62C70",
x"3F1AA2C6C",
x"3EE8F2C68",
x"3EB750C64",
x"3E85C0C61",
x"3E543EC5D",
x"3E22CAC59",
x"3DF166C55",
x"3DC012C51",
x"3D8ECCC4D",
x"3D5D98C4A",
x"3D2C70C46",
x"3CFB5AC42",
x"3CCA50C3E",
x"3C9958C3A",
x"3C686EC37",
x"3C3794C33",
x"3C06C8C2F",
x"3BD60AC2B",
x"3BA55EC28",
x"3B74C0C24",
x"3B4430C20",
x"3B13AEC1C",
x"3AE33EC19",
x"3AB2DAC15",
x"3A8286C11",
x"3A5242C0E",
x"3A220CC0A",
x"39F1E4C06",
x"39C1CCC03",
x"3991C0BFF",
x"3961C4BFB",
x"3931DABF8",
x"3901FABF4",
x"38D22ABF0",
x"38A26CBED",
x"3872B8BE9",
x"384314BE5",
x"381380BE2",
x"37E3F8BDE",
x"37B480BDA",
x"378516BD7",
x"3755BABD3",
x"37266EBD0",
x"36F730BCC",
x"36C7FEBC8",
x"3698DEBC5",
x"3669C8BC1",
x"363AC4BBE",
x"360BCCBBA",
x"35DCE4BB7",
x"35AE08BB3",
x"357F3EBB0",
x"35507EBAC",
x"3521CEBA9",
x"34F32CBA5",
x"34C498BA2",
x"349610B9E",
x"34679AB9B",
x"34392EB97",
x"340AD4B94",
x"33DC84B90",
x"33AE44B8D",
x"338010B89",
x"3351EEB86",
x"3323D6B82",
x"32F5CEB7F",
x"32C7D0B7B",
x"3299E4B78",
x"326C04B74",
x"323E32B71",
x"32106EB6E",
x"31E2B8B6A",
x"31B510B67",
x"318772B63",
x"3159E6B60",
x"312C66B5D",
x"30FEF2B59",
x"30D18EB56",
x"30A438B53",
x"3076ECB4F",
x"3049B0B4C",
x"301C80B48",
x"2FEF5EB45",
x"2FC24AB42",
x"2F9542B3E",
x"2F684AB3B",
x"2F3B5EB38",
x"2F0E7EB34",
x"2EE1ACB31",
x"2EB4E8B2E",
x"2E8832B2B",
x"2E5B86B27",
x"2E2EEAB24",
x"2E025AB21",
x"2DD5D6B1D",
x"2DA962B1A",
x"2D7CFAB17",
x"2D509EB14",
x"2D2450B10",
x"2CF80EB0D",
x"2CCBDAB0A",
x"2C9FB4B07",
x"2C7398B03",
x"2C478AB00",
x"2C1B8AAFD",
x"2BEF98AFA",
x"2BC3B0AF6",
x"2B97D6AF3",
x"2B6C08AF0",
x"2B4048AED",
x"2B1496AEA",
x"2AE8F0AE7",
x"2ABD54AE3",
x"2A91C6AE0",
x"2A6646ADD",
x"2A3AD2ADA",
x"2A0F6CAD7",
x"29E412AD4",
x"29B8C2AD0",
x"298D80ACD",
x"29624CACA",
x"293724AC7",
x"290C08AC4",
x"28E0FAAC1",
x"28B5F6ABE",
x"288B00ABB",
x"286014AB7",
x"283536AB4",
x"280A66AB1",
x"27DFA2AAE",
x"27B4E8AAB",
x"278A3CAA8",
x"275F9EAA5",
x"27350AAA2",
x"270A82A9F",
x"26E008A9C",
x"26B59AA99",
x"268B36A96",
x"2660E0A93",
x"263696A90",
x"260C56A8C",
x"25E224A89",
x"25B7FEA86",
x"258DE4A83",
x"2563D6A80",
x"2539D6A7D",
x"250FE0A7A",
x"24E5F6A77",
x"24BC18A74",
x"249246A71",
x"246880A6E",
x"243EC6A6B",
x"24151AA69",
x"23EB78A66",
x"23C1E2A63",
x"239858A60",
x"236ED8A5D",
x"234566A5A",
x"231BFEA57",
x"22F2A4A54",
x"22C954A51",
x"22A010A4E",
x"2276D8A4B",
x"224DACA48",
x"22248AA45",
x"21FB76A42",
x"21D26CA3F",
x"21A970A3D",
x"21807EA3A",
x"215796A37",
x"212EBCA34",
x"2105ECA31",
x"20DD28A2E",
x"20B46EA2B",
x"208BC0A28",
x"206322A26",
x"203A8AA23",
x"201200A20",
x"1FE980A1D",
x"1FC10CA1A",
x"1F98A2A17",
x"1F7044A14",
x"1F47F4A12",
x"1F1FAEA0F",
x"1EF772A0C",
x"1ECF42A09",
x"1EA71CA06",
x"1E7F04A04",
x"1E56F6A01",
x"1E2EF29FE",
x"1E06FA9FB",
x"1DDF0C9F8",
x"1DB72C9F6",
x"1D8F549F3",
x"1D67889F0",
x"1D3FC89ED",
x"1D18149EB",
x"1CF06A9E8",
x"1CC8CA9E5",
x"1CA1349E2",
x"1C79AC9E0",
x"1C522E9DD",
x"1C2ABA9DA",
x"1C03529D7",
x"1BDBF69D5",
x"1BB4A29D2",
x"1B8D5A9CF",
x"1B661C9CC",
x"1B3EEC9CA",
x"1B17C49C7",
x"1AF0A89C4",
x"1AC9989C2",
x"1AA2909BF",
x"1A7B949BC",
x"1A54A49BA",
x"1A2DBC9B7",
x"1A06E09B4",
x"19E0109B2",
x"19B94A9AF",
x"19928E9AC",
x"196BDE9AA",
x"1945369A7",
x"191E9A9A4",
x"18F80A9A2",
x"18D18299F",
x"18AB0699C",
x"18849699A",
x"185E2E997",
x"1837D2995",
x"181180992",
x"17EB3898F",
x"17C4FC98D",
x"179EC898A",
x"17789E987",
x"175282985",
x"172C6E982",
x"170666980",
x"16E06697D",
x"16BA7497B",
x"169488978",
x"166EA8975",
x"1648D4973",
x"162308970",
x"15FD4896E",
x"15D79096B",
x"15B1E6969",
x"158C42966",
x"1566A8963",
x"15411C961",
x"151B9895E",
x"14F62095C",
x"14D0AE959",
x"14AB4A957",
x"1485EE954",
x"14609E952",
x"143B5694F",
x"14161A94D",
x"13F0E694A",
x"13CBBE948",
x"13A69E945",
x"13818A943",
x"135C7E940",
x"13377E93E",
x"13128693B",
x"12ED9A939",
x"12C8B6936",
x"12A3DE934",
x"127F0E931",
x"125A4892F",
x"12358C92C",
x"1210DA92A",
x"11EC34928",
x"11C794925",
x"11A300923",
x"117E74920",
x"1159F491E",
x"11357C91B",
x"111110919",
x"10ECAC917",
x"10C852914",
x"10A402912",
x"107FBA90F",
x"105B7E90D",
x"10374890A",
x"101320908",
x"0FEF00906",
x"0FCAE8903",
x"0FA6DC901",
x"0F82D88FF",
x"0F5EDE8FC",
x"0F3AEE8FA",
x"0F17068F7",
x"0EF3288F5",
x"0ECF568F3",
x"0EAB8A8F0",
x"0E87CA8EE",
x"0E64128EC",
x"0E40648E9",
x"0E1CC08E7",
x"0DF9248E5",
x"0DD5928E2",
x"0DB20A8E0",
x"0D8E888DD",
x"0D6B148DB",
x"0D47A88D9",
x"0D24448D7",
x"0D00EA8D4",
x"0CDD9A8D2",
x"0CBA528D0",
x"0C97128CD",
x"0C73DE8CB",
x"0C50B48C9",
x"0C2D908C6",
x"0C0A768C4",
x"0BE7688C2",
x"0BC45E8BF",
x"0BA1628BD",
x"0B7E6E8BB",
x"0B5B828B9",
x"0B389E8B6",
x"0B15C68B4",
x"0AF2F68B2",
x"0AD0308B0",
x"0AAD708AD",
x"0A8ABA8AB",
x"0A68108A9",
x"0A456C8A7",
x"0A22D28A4",
x"0A00408A2",
x"09DDBA8A0",
x"09BB3A89E",
x"0998C289B",
x"097656899",
x"0953F2897",
x"093198895",
x"090F44892",
x"08ECFA890",
x"08CABA88E",
x"08A88288C",
x"08865488A",
x"08642C887",
x"08420E885",
x"081FFA883",
x"07FDEE881",
x"07DBEC87F",
x"07B9F087C",
x"0797FE87A",
x"077616878",
x"075436876",
x"073260874",
x"071092872",
x"06EECA86F",
x"06CD0C86D",
x"06AB5886B",
x"0689AC869",
x"06680A867",
x"06466E865",
x"0624DA862",
x"060352860",
x"05E1D085E",
x"05C05885C",
x"059EE885A",
x"057D82858",
x"055C22856",
x"053ACA853",
x"05197E851",
x"04F83884F",
x"04D6FC84D",
x"04B5C884B",
x"04949C849",
x"047378847",
x"04525C845",
x"04314A843",
x"04103E840",
x"03EF3C83E",
x"03CE4483C",
x"03AD5283A",
x"038C6A838",
x"036B8A836",
x"034AB2834",
x"0329E2832",
x"03091A830",
x"02E85A82E",
x"02C7A482C",
x"02A6F682A",
x"02864E828",
x"0265B0826",
x"024518823",
x"02248C821",
x"02040681F",
x"01E38881D",
x"01C31481B",
x"01A2A6819",
x"018242817",
x"0161E4815",
x"014190813",
x"012144811",
x"01010080F",
x"00E0C280D",
x"00C08E80B",
x"00A062809",
x"00803E807",
x"006022805",
x"00400E803",
x"002002801"
);

begin
	prom_sim: process(clka)
	begin
		if rising_edge(clka) then
			addr_in <= conv_integer(addra);
			douta <= table(addr_in);
		end if;
	end process;
end op;
