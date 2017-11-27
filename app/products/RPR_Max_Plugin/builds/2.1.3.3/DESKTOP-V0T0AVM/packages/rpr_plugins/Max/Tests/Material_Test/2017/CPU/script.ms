resetMaxFile #noPrompt
SetQuietMode true
-- main parameters
PASS_LIMIT = 20
RENDER_SIZE = 512

FILE_EXTENSION = ".png" -- for the renderings

res_path = "D:\\jobs_launcher_main\\tests\\packages\\rpr_plugins\\Max\\..\\..\\..\\assets\\Max\\scenes"

function createCatalog = (
    OUT_DIR = "D:\\jobs_launcher_main\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Material_Test\\2017\\CPU\\"

    units.SystemType = #Meters
    renderers.current = Radeon_ProRender()
    fr = renderers.current
    fr.renderLimit = 1
    fr.passLimit = PASS_LIMIT
    fr.renderDevice = 1

    result = OUT_DIR + "report.json" 
    a = (createFile result mode:"w")
    line = "[\n"
    format "%" line to:a

    filesToRender = #(
        LibEntry "RPR_CarPaints.mat" "SpeedShape"
--,LibEntry "RPR_Composites.mat",
--LibEntry "RPR_Concrete.mat",
--LibEntry "RPR_Emissive.mat",
--LibEntry "RPR_ExtendedMetals.mat",
--LibEntry "RPR_Fabric.mat" "Cloth",
--LibEntry "RPR_Fur.mat" "Displacement",
--LibEntry "RPR_Glass.mat",
--LibEntry "RPR_Ground.mat" "Displacement",
--LibEntry "RPR_Jewels.mat" "Diamonds",
--LibEntry "RPR_Leather.mat",
--LibEntry "RPR_Liquid.mat" "Pool",
--LibEntry "RPR_Metallic_Paint.mat" "SpeedShape",
--LibEntry "RPR_Metals.mat",
--LibEntry "RPR_Paint.mat" "Wall",
--LibEntry "RPR_Paper.mat",
--LibEntry "RPR_Plastic.mat",
--LibEntry "RPR_Porcelain.mat",
--LibEntry "RPR_PreciousMetals.mat" "Rigns",
--LibEntry "RPR_Render_Stone.mat" "Wall",
--LibEntry "RPR_Render_Tiles.mat" "Wall",
--LibEntry "RPR_Roofing.mat" "Wall",
--LibEntry "RPR_Rubber.mat" "Tyre",
--LibEntry "RPR_ShadowCatchers.mat" "Wall",
--LibEntry "RPR_UberTemplates.mat",
--LibEntry "RPR_TransparentPlastic.mat",
--LibEntry "RPR_WallCovering.mat" "Wall",
--LibEntry "RPR_Wood.mat",
--LibEntry "RPR_UberTemplates.mat",
--LibEntry "RPR_Volumes.mat"
    )

    count_file = OUT_DIR + "\\expected.json"
    t = (createFile count_file mode:"w")
    line = "[\n"
    format "%" line to:t

    for fi=1 to filesToRender.count do (
        local framesToRender = #(20,40,60,80,90,100)
        assetsFile = res_path + filesToRender[fi]
        loadMaxFile assetsFile quiet:true
        for fra in framesToRender do (
            if fi != filesToRender.count do(
--                 mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\n"
                mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)    + FILE_EXTENSION +"\"},\n"
                format "%" mfilename to:t
            )
            
            if fi == filesToRender.count do(
                if fra != 100 do (
--                     mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\n"
                    mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)    + FILE_EXTENSION +"\"},\n"
                    format "%" mfilename to:t
                ) 
                if fra == 100 do (
--                     mfilename = maxFileName + "_" + (fra as string)  + FILE_EXTENSION
                    mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)    + FILE_EXTENSION +"\"}\n"
                    format "%" mfilename to:t
                )
            )
        )
    )

    e_line = "]"
    format "%" e_line to:t
    flush t
    close t

    IMAGE_DIR = OUT_DIR + "\\images\\"
    makeDir IMAGE_DIR
    for fi=1 to filesToRender.count do (
        assetsFile = res_path + filesToRender[fi]
        loadMaxFile assetsFile quiet:true
        fr = renderers.current
        fr.passLimit = PASS_LIMIT
        fr.renderDevice = 1
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
                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                    format "%" temp_line to:a
                    )
                if fra == 100 do(
                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                    format "%" temp_line to:a
                    )
                )
            if fi == filesToRender.count do(
                if fra != 100 do(
                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                    format "%" temp_line to:a
                    )                                                     
                if fra == 100 do(
                    temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n }\n"
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
