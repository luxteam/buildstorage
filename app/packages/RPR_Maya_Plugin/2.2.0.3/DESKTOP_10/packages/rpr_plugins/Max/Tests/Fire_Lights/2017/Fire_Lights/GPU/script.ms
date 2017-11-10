resetMaxFile #noPrompt
SetQuietMode true
-- main parameters
PASS_LIMIT = 20
RENDER_SIZE = 512

FILE_EXTENSION = ".png" -- for the renderings

res_path = "D:\\jobs_launcher\\tests\\packages\\rpr_plugins\\Max\\..\\..\\..\\assets\\Max\\scenes"

function createCatalog = (
	
	OUT_DIR = "D:\\jobs_launcher\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Fire_Lights\\2017\\Fire_Lights\\GPU\\"

    units.SystemType = #Meters
        renderers.current = Radeon_ProRender()
	fr = renderers.current
	fr.renderLimit = 1
	fr.passLimit = PASS_LIMIT
        fr.renderDevice = 2

        result = OUT_DIR + "report.json" 
        a = (createFile result mode:"w")
        line = "[\n"
        format "%" line to:a

        filesToRender = #(
        "\\RPR_Production_IBL.max"
--,"\\RPR_Production_Sun and Sky.max",
--"\\RPR_Production_IBL_PhTargetLight.max",
--"\\RPR_Production_PhotoTargetLight.max",
--"\\RPR_Production_PhotoFreeLight.max",
--"\RPR_Production_StandTargetDirectLight.max",
--"\\RPR_Production_StandTargetSpotLight.max",
--"\\RPR_Production_StandFreeDirectLight.max",
--"\\RPR_Production_StandFreeSpotLight.max",
--"\\RPR_Production_StandFreeOmniLight.max",
--"\\RPR_Production_StandFreeSkyLight.max"
        )
	
        count_file = OUT_DIR + "image_list.txt" 
	t = (createFile count_file mode:"w")
	
	for fi=1 to filesToRender.count do (
               local framesToRender = #(20,40,60,80,90,100)
		assetsFile = res_path + filesToRender[fi]
		loadMaxFile assetsFile quiet:true
		for fra in framesToRender do (
                    if fi != filesToRender.count do(
                         mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\n"
			   format "%" mfilename to:t
                   )
                   if fi == filesToRender.count do(

                          if fra != 100 do (
	           mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\n"
			   format "%" mfilename to:t
                   ) 
                           if fra == 100 do (
                  mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION
			   format "%" mfilename to:t
                   )
                 )
               )
		)	
	flush t
	close t
        IMAGE_DIR = OUT_DIR + "\\images\\"
        makeDir IMAGE_DIR
	for fi=1 to filesToRender.count do (
		assetsFile = res_path + filesToRender[fi]
		loadMaxFile assetsFile quiet:true
		fr = renderers.current
	    fr.passLimit = PASS_LIMIT
		fr.renderDevice = 2
		local framesToRender = #(20,40,60,80,90,100)

		for fra in framesToRender do (
			mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION
			mpath = IMAGE_DIR + mfilename
			rstart = timeStamp()
			render outputwidth:RENDER_SIZE outputheight:RENDER_SIZE frame:fra outputfile:mpath vfb:true
			rend = timeStamp()
			relapsed = ((rend - rstart) / 1000.0)
			ver_max = filterString (getdir #maxroot) "\\"
                        scene_json = filterString (filesToRender[fi]) "\\"
	        if fi != filesToRender.count do (
                             if fra != 100 do(
                                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"GPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"filename\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                                    format "%" temp_line to:a
                                             )
                             if fra == 100 do(
                                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"GPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"filename\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                                    format "%" temp_line to:a
)
)
		if fi == filesToRender.count do(
                            if fra != 100 do(
                                   temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"GPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"filename\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                                   format "%" temp_line to:a
)                                                     
                            if fra == 100 do(
                                   temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"GPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"filename\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n }\n"
                                   format "%" temp_line to:a
)
)
			
			
	)	
	)
		
        e_line = "]"
        format "%" e_line to:a
        flush a
        close a	
	
)


createCatalog()
resetMaxFile #noPrompt
quitMax #noPrompt
