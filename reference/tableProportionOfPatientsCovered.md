# Create a table with proportion of patients covered results

Create a table with proportion of patients covered results

## Usage

``` r
tableProportionOfPatientsCovered(
  result,
  header = c("cohort_name", strataColumns(result)),
  groupColumn = "cdm_name",
  type = NULL,
  hide = c("variable_name", "variable_level", "cohort_table_name"),
  style = NULL,
  .options = list()
)
```

## Arguments

- result:

  A summarised_result object.

- header:

  Columns to use as header. See options with
  `availableTableColumns(result)`.

- groupColumn:

  Columns to group by. See options with `availableTableColumns(result)`.

- type:

  Character string specifying the desired output table format. See
  [`visOmopResults::tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)
  for supported table types. If type = `NULL`, global options (set via
  [`visOmopResults::setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html))
  will be used if available; otherwise, a default 'gt' table is created.

- hide:

  Columns to hide from the visualisation. See options with
  `availableTableColumns(result)`.

- style:

  Defines the visual formatting of the table. This argument can be
  provided in one of the following ways:

  1.  **Pre-defined style**: Use the name of a built-in style (e.g.,
      "darwin"). See
      [`visOmopResults::tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)
      for available options.

  2.  **YAML file path**: Provide the path to an existing .yml file
      defining a new style.

  3.  **List of custome R code**: Supply a block of custom R code or a
      named list describing styles for each table section. This code
      must be specific to the selected table type.

  If style = `NULL`, the function will use global options (see
  [`visOmopResults::setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html))
  or an existing `_brand.yml` file (if found); otherwise, the default
  style is applied. For more details, see the *Styles* vignette in
  **visOmopResults** website.

- .options:

  A named list with additional formatting options.
  [`visOmopResults::tableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)
  shows allowed arguments and their default values.

## Value

A table with a formatted version of
summariseProportionOfPatientsCovered() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "my_cohort",
                                        conceptSet = list(drug_of_interest = c(1503297, 1503327)))
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

result <- cdm$my_cohort |>
  summariseProportionOfPatientsCovered(followUpDays = 365)
#> Getting PPC for cohort drug_of_interest
#> Collecting cohort into memory
#> Geting PPC over 365 days following first cohort entry
#>  -- getting PPC for ■■■■■■■■■■                       106 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■                 177 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days

tableProportionOfPatientsCovered(result)
#> cdm_name, cohort_name, variable_name, variable_level, and cohort_table_name are
#> missing in `columnOrder`, will be added last.
#> ℹ <ppc>% has not been formatted.
#> ℹ <ppc_lower>% has not been formatted.
#> ℹ <ppc_upper>% has not been formatted.


  


Time
```

Estimate name

Cohort name

drug_of_interest

DUS MOCK

0

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

1

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

2

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

3

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

4

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

5

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

6

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

7

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

8

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

9

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

10

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

11

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

12

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

13

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

14

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

15

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

16

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

17

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

18

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

19

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

20

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

21

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

22

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

23

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

24

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

25

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

26

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

27

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

28

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

29

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

30

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

31

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

32

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

33

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

34

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

35

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

36

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

37

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

38

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

39

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

40

PPC (95%CI)

100.00% \[20.65% - 100.00%\]

41

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

42

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

43

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

44

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

45

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

46

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

47

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

48

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

49

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

50

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

51

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

52

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

53

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

54

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

55

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

56

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

57

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

58

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

59

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

60

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

61

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

62

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

63

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

64

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

65

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

66

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

67

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

68

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

69

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

70

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

71

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

72

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

73

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

74

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

75

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

76

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

77

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

78

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

79

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

80

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

81

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

82

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

83

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

84

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

85

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

86

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

87

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

88

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

89

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

90

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

91

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

92

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

93

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

94

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

95

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

96

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

97

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

98

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

99

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

100

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

101

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

102

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

103

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

104

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

105

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

106

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

107

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

108

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

109

PPC (95%CI)

0.00% \[0.00% - 79.35%\]

110

PPC (95%CI)

NaN% \[NaN% - NaN%\]

111

PPC (95%CI)

NaN% \[NaN% - NaN%\]

112

PPC (95%CI)

NaN% \[NaN% - NaN%\]

113

PPC (95%CI)

NaN% \[NaN% - NaN%\]

114

PPC (95%CI)

NaN% \[NaN% - NaN%\]

115

PPC (95%CI)

NaN% \[NaN% - NaN%\]

116

PPC (95%CI)

NaN% \[NaN% - NaN%\]

117

PPC (95%CI)

NaN% \[NaN% - NaN%\]

118

PPC (95%CI)

NaN% \[NaN% - NaN%\]

119

PPC (95%CI)

NaN% \[NaN% - NaN%\]

120

PPC (95%CI)

NaN% \[NaN% - NaN%\]

121

PPC (95%CI)

NaN% \[NaN% - NaN%\]

122

PPC (95%CI)

NaN% \[NaN% - NaN%\]

123

PPC (95%CI)

NaN% \[NaN% - NaN%\]

124

PPC (95%CI)

NaN% \[NaN% - NaN%\]

125

PPC (95%CI)

NaN% \[NaN% - NaN%\]

126

PPC (95%CI)

NaN% \[NaN% - NaN%\]

127

PPC (95%CI)

NaN% \[NaN% - NaN%\]

128

PPC (95%CI)

NaN% \[NaN% - NaN%\]

129

PPC (95%CI)

NaN% \[NaN% - NaN%\]

130

PPC (95%CI)

NaN% \[NaN% - NaN%\]

131

PPC (95%CI)

NaN% \[NaN% - NaN%\]

132

PPC (95%CI)

NaN% \[NaN% - NaN%\]

133

PPC (95%CI)

NaN% \[NaN% - NaN%\]

134

PPC (95%CI)

NaN% \[NaN% - NaN%\]

135

PPC (95%CI)

NaN% \[NaN% - NaN%\]

136

PPC (95%CI)

NaN% \[NaN% - NaN%\]

137

PPC (95%CI)

NaN% \[NaN% - NaN%\]

138

PPC (95%CI)

NaN% \[NaN% - NaN%\]

139

PPC (95%CI)

NaN% \[NaN% - NaN%\]

140

PPC (95%CI)

NaN% \[NaN% - NaN%\]

141

PPC (95%CI)

NaN% \[NaN% - NaN%\]

142

PPC (95%CI)

NaN% \[NaN% - NaN%\]

143

PPC (95%CI)

NaN% \[NaN% - NaN%\]

144

PPC (95%CI)

NaN% \[NaN% - NaN%\]

145

PPC (95%CI)

NaN% \[NaN% - NaN%\]

146

PPC (95%CI)

NaN% \[NaN% - NaN%\]

147

PPC (95%CI)

NaN% \[NaN% - NaN%\]

148

PPC (95%CI)

NaN% \[NaN% - NaN%\]

149

PPC (95%CI)

NaN% \[NaN% - NaN%\]

150

PPC (95%CI)

NaN% \[NaN% - NaN%\]

151

PPC (95%CI)

NaN% \[NaN% - NaN%\]

152

PPC (95%CI)

NaN% \[NaN% - NaN%\]

153

PPC (95%CI)

NaN% \[NaN% - NaN%\]

154

PPC (95%CI)

NaN% \[NaN% - NaN%\]

155

PPC (95%CI)

NaN% \[NaN% - NaN%\]

156

PPC (95%CI)

NaN% \[NaN% - NaN%\]

157

PPC (95%CI)

NaN% \[NaN% - NaN%\]

158

PPC (95%CI)

NaN% \[NaN% - NaN%\]

159

PPC (95%CI)

NaN% \[NaN% - NaN%\]

160

PPC (95%CI)

NaN% \[NaN% - NaN%\]

161

PPC (95%CI)

NaN% \[NaN% - NaN%\]

162

PPC (95%CI)

NaN% \[NaN% - NaN%\]

163

PPC (95%CI)

NaN% \[NaN% - NaN%\]

164

PPC (95%CI)

NaN% \[NaN% - NaN%\]

165

PPC (95%CI)

NaN% \[NaN% - NaN%\]

166

PPC (95%CI)

NaN% \[NaN% - NaN%\]

167

PPC (95%CI)

NaN% \[NaN% - NaN%\]

168

PPC (95%CI)

NaN% \[NaN% - NaN%\]

169

PPC (95%CI)

NaN% \[NaN% - NaN%\]

170

PPC (95%CI)

NaN% \[NaN% - NaN%\]

171

PPC (95%CI)

NaN% \[NaN% - NaN%\]

172

PPC (95%CI)

NaN% \[NaN% - NaN%\]

173

PPC (95%CI)

NaN% \[NaN% - NaN%\]

174

PPC (95%CI)

NaN% \[NaN% - NaN%\]

175

PPC (95%CI)

NaN% \[NaN% - NaN%\]

176

PPC (95%CI)

NaN% \[NaN% - NaN%\]

177

PPC (95%CI)

NaN% \[NaN% - NaN%\]

178

PPC (95%CI)

NaN% \[NaN% - NaN%\]

179

PPC (95%CI)

NaN% \[NaN% - NaN%\]

180

PPC (95%CI)

NaN% \[NaN% - NaN%\]

181

PPC (95%CI)

NaN% \[NaN% - NaN%\]

182

PPC (95%CI)

NaN% \[NaN% - NaN%\]

183

PPC (95%CI)

NaN% \[NaN% - NaN%\]

184

PPC (95%CI)

NaN% \[NaN% - NaN%\]

185

PPC (95%CI)

NaN% \[NaN% - NaN%\]

186

PPC (95%CI)

NaN% \[NaN% - NaN%\]

187

PPC (95%CI)

NaN% \[NaN% - NaN%\]

188

PPC (95%CI)

NaN% \[NaN% - NaN%\]

189

PPC (95%CI)

NaN% \[NaN% - NaN%\]

190

PPC (95%CI)

NaN% \[NaN% - NaN%\]

191

PPC (95%CI)

NaN% \[NaN% - NaN%\]

192

PPC (95%CI)

NaN% \[NaN% - NaN%\]

193

PPC (95%CI)

NaN% \[NaN% - NaN%\]

194

PPC (95%CI)

NaN% \[NaN% - NaN%\]

195

PPC (95%CI)

NaN% \[NaN% - NaN%\]

196

PPC (95%CI)

NaN% \[NaN% - NaN%\]

197

PPC (95%CI)

NaN% \[NaN% - NaN%\]

198

PPC (95%CI)

NaN% \[NaN% - NaN%\]

199

PPC (95%CI)

NaN% \[NaN% - NaN%\]

200

PPC (95%CI)

NaN% \[NaN% - NaN%\]

201

PPC (95%CI)

NaN% \[NaN% - NaN%\]

202

PPC (95%CI)

NaN% \[NaN% - NaN%\]

203

PPC (95%CI)

NaN% \[NaN% - NaN%\]

204

PPC (95%CI)

NaN% \[NaN% - NaN%\]

205

PPC (95%CI)

NaN% \[NaN% - NaN%\]

206

PPC (95%CI)

NaN% \[NaN% - NaN%\]

207

PPC (95%CI)

NaN% \[NaN% - NaN%\]

208

PPC (95%CI)

NaN% \[NaN% - NaN%\]

209

PPC (95%CI)

NaN% \[NaN% - NaN%\]

210

PPC (95%CI)

NaN% \[NaN% - NaN%\]

211

PPC (95%CI)

NaN% \[NaN% - NaN%\]

212

PPC (95%CI)

NaN% \[NaN% - NaN%\]

213

PPC (95%CI)

NaN% \[NaN% - NaN%\]

214

PPC (95%CI)

NaN% \[NaN% - NaN%\]

215

PPC (95%CI)

NaN% \[NaN% - NaN%\]

216

PPC (95%CI)

NaN% \[NaN% - NaN%\]

217

PPC (95%CI)

NaN% \[NaN% - NaN%\]

218

PPC (95%CI)

NaN% \[NaN% - NaN%\]

219

PPC (95%CI)

NaN% \[NaN% - NaN%\]

220

PPC (95%CI)

NaN% \[NaN% - NaN%\]

221

PPC (95%CI)

NaN% \[NaN% - NaN%\]

222

PPC (95%CI)

NaN% \[NaN% - NaN%\]

223

PPC (95%CI)

NaN% \[NaN% - NaN%\]

224

PPC (95%CI)

NaN% \[NaN% - NaN%\]

225

PPC (95%CI)

NaN% \[NaN% - NaN%\]

226

PPC (95%CI)

NaN% \[NaN% - NaN%\]

227

PPC (95%CI)

NaN% \[NaN% - NaN%\]

228

PPC (95%CI)

NaN% \[NaN% - NaN%\]

229

PPC (95%CI)

NaN% \[NaN% - NaN%\]

230

PPC (95%CI)

NaN% \[NaN% - NaN%\]

231

PPC (95%CI)

NaN% \[NaN% - NaN%\]

232

PPC (95%CI)

NaN% \[NaN% - NaN%\]

233

PPC (95%CI)

NaN% \[NaN% - NaN%\]

234

PPC (95%CI)

NaN% \[NaN% - NaN%\]

235

PPC (95%CI)

NaN% \[NaN% - NaN%\]

236

PPC (95%CI)

NaN% \[NaN% - NaN%\]

237

PPC (95%CI)

NaN% \[NaN% - NaN%\]

238

PPC (95%CI)

NaN% \[NaN% - NaN%\]

239

PPC (95%CI)

NaN% \[NaN% - NaN%\]

240

PPC (95%CI)

NaN% \[NaN% - NaN%\]

241

PPC (95%CI)

NaN% \[NaN% - NaN%\]

242

PPC (95%CI)

NaN% \[NaN% - NaN%\]

243

PPC (95%CI)

NaN% \[NaN% - NaN%\]

244

PPC (95%CI)

NaN% \[NaN% - NaN%\]

245

PPC (95%CI)

NaN% \[NaN% - NaN%\]

246

PPC (95%CI)

NaN% \[NaN% - NaN%\]

247

PPC (95%CI)

NaN% \[NaN% - NaN%\]

248

PPC (95%CI)

NaN% \[NaN% - NaN%\]

249

PPC (95%CI)

NaN% \[NaN% - NaN%\]

250

PPC (95%CI)

NaN% \[NaN% - NaN%\]

251

PPC (95%CI)

NaN% \[NaN% - NaN%\]

252

PPC (95%CI)

NaN% \[NaN% - NaN%\]

253

PPC (95%CI)

NaN% \[NaN% - NaN%\]

254

PPC (95%CI)

NaN% \[NaN% - NaN%\]

255

PPC (95%CI)

NaN% \[NaN% - NaN%\]

256

PPC (95%CI)

NaN% \[NaN% - NaN%\]

257

PPC (95%CI)

NaN% \[NaN% - NaN%\]

258

PPC (95%CI)

NaN% \[NaN% - NaN%\]

259

PPC (95%CI)

NaN% \[NaN% - NaN%\]

260

PPC (95%CI)

NaN% \[NaN% - NaN%\]

261

PPC (95%CI)

NaN% \[NaN% - NaN%\]

262

PPC (95%CI)

NaN% \[NaN% - NaN%\]

263

PPC (95%CI)

NaN% \[NaN% - NaN%\]

264

PPC (95%CI)

NaN% \[NaN% - NaN%\]

265

PPC (95%CI)

NaN% \[NaN% - NaN%\]

266

PPC (95%CI)

NaN% \[NaN% - NaN%\]

267

PPC (95%CI)

NaN% \[NaN% - NaN%\]

268

PPC (95%CI)

NaN% \[NaN% - NaN%\]

269

PPC (95%CI)

NaN% \[NaN% - NaN%\]

270

PPC (95%CI)

NaN% \[NaN% - NaN%\]

271

PPC (95%CI)

NaN% \[NaN% - NaN%\]

272

PPC (95%CI)

NaN% \[NaN% - NaN%\]

273

PPC (95%CI)

NaN% \[NaN% - NaN%\]

274

PPC (95%CI)

NaN% \[NaN% - NaN%\]

275

PPC (95%CI)

NaN% \[NaN% - NaN%\]

276

PPC (95%CI)

NaN% \[NaN% - NaN%\]

277

PPC (95%CI)

NaN% \[NaN% - NaN%\]

278

PPC (95%CI)

NaN% \[NaN% - NaN%\]

279

PPC (95%CI)

NaN% \[NaN% - NaN%\]

280

PPC (95%CI)

NaN% \[NaN% - NaN%\]

281

PPC (95%CI)

NaN% \[NaN% - NaN%\]

282

PPC (95%CI)

NaN% \[NaN% - NaN%\]

283

PPC (95%CI)

NaN% \[NaN% - NaN%\]

284

PPC (95%CI)

NaN% \[NaN% - NaN%\]

285

PPC (95%CI)

NaN% \[NaN% - NaN%\]

286

PPC (95%CI)

NaN% \[NaN% - NaN%\]

287

PPC (95%CI)

NaN% \[NaN% - NaN%\]

288

PPC (95%CI)

NaN% \[NaN% - NaN%\]

289

PPC (95%CI)

NaN% \[NaN% - NaN%\]

290

PPC (95%CI)

NaN% \[NaN% - NaN%\]

291

PPC (95%CI)

NaN% \[NaN% - NaN%\]

292

PPC (95%CI)

NaN% \[NaN% - NaN%\]

293

PPC (95%CI)

NaN% \[NaN% - NaN%\]

294

PPC (95%CI)

NaN% \[NaN% - NaN%\]

295

PPC (95%CI)

NaN% \[NaN% - NaN%\]

296

PPC (95%CI)

NaN% \[NaN% - NaN%\]

297

PPC (95%CI)

NaN% \[NaN% - NaN%\]

298

PPC (95%CI)

NaN% \[NaN% - NaN%\]

299

PPC (95%CI)

NaN% \[NaN% - NaN%\]

300

PPC (95%CI)

NaN% \[NaN% - NaN%\]

301

PPC (95%CI)

NaN% \[NaN% - NaN%\]

302

PPC (95%CI)

NaN% \[NaN% - NaN%\]

303

PPC (95%CI)

NaN% \[NaN% - NaN%\]

304

PPC (95%CI)

NaN% \[NaN% - NaN%\]

305

PPC (95%CI)

NaN% \[NaN% - NaN%\]

306

PPC (95%CI)

NaN% \[NaN% - NaN%\]

307

PPC (95%CI)

NaN% \[NaN% - NaN%\]

308

PPC (95%CI)

NaN% \[NaN% - NaN%\]

309

PPC (95%CI)

NaN% \[NaN% - NaN%\]

310

PPC (95%CI)

NaN% \[NaN% - NaN%\]

311

PPC (95%CI)

NaN% \[NaN% - NaN%\]

312

PPC (95%CI)

NaN% \[NaN% - NaN%\]

313

PPC (95%CI)

NaN% \[NaN% - NaN%\]

314

PPC (95%CI)

NaN% \[NaN% - NaN%\]

315

PPC (95%CI)

NaN% \[NaN% - NaN%\]

316

PPC (95%CI)

NaN% \[NaN% - NaN%\]

317

PPC (95%CI)

NaN% \[NaN% - NaN%\]

318

PPC (95%CI)

NaN% \[NaN% - NaN%\]

319

PPC (95%CI)

NaN% \[NaN% - NaN%\]

320

PPC (95%CI)

NaN% \[NaN% - NaN%\]

321

PPC (95%CI)

NaN% \[NaN% - NaN%\]

322

PPC (95%CI)

NaN% \[NaN% - NaN%\]

323

PPC (95%CI)

NaN% \[NaN% - NaN%\]

324

PPC (95%CI)

NaN% \[NaN% - NaN%\]

325

PPC (95%CI)

NaN% \[NaN% - NaN%\]

326

PPC (95%CI)

NaN% \[NaN% - NaN%\]

327

PPC (95%CI)

NaN% \[NaN% - NaN%\]

328

PPC (95%CI)

NaN% \[NaN% - NaN%\]

329

PPC (95%CI)

NaN% \[NaN% - NaN%\]

330

PPC (95%CI)

NaN% \[NaN% - NaN%\]

331

PPC (95%CI)

NaN% \[NaN% - NaN%\]

332

PPC (95%CI)

NaN% \[NaN% - NaN%\]

333

PPC (95%CI)

NaN% \[NaN% - NaN%\]

334

PPC (95%CI)

NaN% \[NaN% - NaN%\]

335

PPC (95%CI)

NaN% \[NaN% - NaN%\]

336

PPC (95%CI)

NaN% \[NaN% - NaN%\]

337

PPC (95%CI)

NaN% \[NaN% - NaN%\]

338

PPC (95%CI)

NaN% \[NaN% - NaN%\]

339

PPC (95%CI)

NaN% \[NaN% - NaN%\]

340

PPC (95%CI)

NaN% \[NaN% - NaN%\]

341

PPC (95%CI)

NaN% \[NaN% - NaN%\]

342

PPC (95%CI)

NaN% \[NaN% - NaN%\]

343

PPC (95%CI)

NaN% \[NaN% - NaN%\]

344

PPC (95%CI)

NaN% \[NaN% - NaN%\]

345

PPC (95%CI)

NaN% \[NaN% - NaN%\]

346

PPC (95%CI)

NaN% \[NaN% - NaN%\]

347

PPC (95%CI)

NaN% \[NaN% - NaN%\]

348

PPC (95%CI)

NaN% \[NaN% - NaN%\]

349

PPC (95%CI)

NaN% \[NaN% - NaN%\]

350

PPC (95%CI)

NaN% \[NaN% - NaN%\]

351

PPC (95%CI)

NaN% \[NaN% - NaN%\]

352

PPC (95%CI)

NaN% \[NaN% - NaN%\]

353

PPC (95%CI)

NaN% \[NaN% - NaN%\]

354

PPC (95%CI)

NaN% \[NaN% - NaN%\]

355

PPC (95%CI)

NaN% \[NaN% - NaN%\]

356

PPC (95%CI)

NaN% \[NaN% - NaN%\]

357

PPC (95%CI)

NaN% \[NaN% - NaN%\]

358

PPC (95%CI)

NaN% \[NaN% - NaN%\]

359

PPC (95%CI)

NaN% \[NaN% - NaN%\]

360

PPC (95%CI)

NaN% \[NaN% - NaN%\]

361

PPC (95%CI)

NaN% \[NaN% - NaN%\]

362

PPC (95%CI)

NaN% \[NaN% - NaN%\]

363

PPC (95%CI)

NaN% \[NaN% - NaN%\]

364

PPC (95%CI)

NaN% \[NaN% - NaN%\]

365

PPC (95%CI)

NaN% \[NaN% - NaN%\]

\# }
