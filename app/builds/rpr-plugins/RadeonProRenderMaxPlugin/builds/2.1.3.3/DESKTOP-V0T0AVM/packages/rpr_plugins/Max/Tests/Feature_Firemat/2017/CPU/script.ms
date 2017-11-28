resetMaxFile #noPrompt
SetQuietMode true
-- main parameters
PASS_LIMIT = 20
RENDER_SIZE = 512

FILE_EXTENSION = ".png" -- for the renderings

res_path = "D:\\jobs_launcher_main\\tests\\packages\\rpr_plugins\\Max\\..\\..\\..\\assets\\Max\\scenes"

function createCatalog = (
    
    OUT_DIR = "D:\\jobs_launcher_main\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Feature_Firemat\\2017\\CPU\\"

    renderers.current= Radeon_ProRender()
    fr = renderers.current
    fr.renderLimit = 1
    fr.passLimit = PASS_LIMIT
    fr.renderDevice = 1

    result = "D:\\jobs_launcher_main\\work\\MaxMaya\\DESKTOP-V0T0AVM\\packages\\rpr_plugins\\Max\\Tests\\Feature_Firemat\\2017\\CPU\\" + "report.json"
    a = (createFile result mode:"w")
    line = "[\n"
    format "%" line to:a

    filesToRender = #(
    "\\RPR Diffuse Material.max"
--,"\\RPR Diffuse_Refraction.max"
--,"\\RPR Diffuse Material Bitmap.max",
--"\\RPR Emissive.max",
--"\\RPR FRMaterial_Displacement.max",
--"\\RPR FRMaterial_Normal.max",
--"\\RPR Emissive_Blend.max",
--"\\RPR Microfacet_Material.max",
--"\\RPR Microfacet_Refraction.max",
--"\\RPR Microfacet_Roughness.max",
--"\\RPR Oren-Nayar.max",
--"\\RPR Reflection.max",
--"\\RPR Refraction.max",
--"\\RPR Transparency.max",
--"\\RPR Roughness.max",
--"\\RPR Ward.max",
--"\\RPR Diffuse Material ColorCorrect.max",
--"\\RPR Diffuse Material Composite.max",
--"\\RPR Diffuse Material Dent.max",
--"\\RPR Diffuse Material Falloff_Fresnel.max",
--"\\RPR Diffuse Material GradientRamp.max",
--"\\RPR Diffuse Material Marble.max",
--"\\RPR Diffuse Material Mask.max",
--"\\RPR Diffuse Material Noise.max",
--"\\RPR Diffuse Material RGBmultiply.max",
--"\\RPR Diffuse Material RGBtint.max",
--"\\RPR Diffuse Material Smoke.max",
--"\\RPR Diffuse Material Speckle.max",
--"\\RPR Diffuse Material Splat.max",
--"\\RPR Diffuse Material Stucco.max",
--"\\RPR Diffuse Material Swirl.max",
--"\\RPR Diffuse Material TextMap.max",
--"\\RPR Diffuse Material Tiles.max",
--"\\RPR Diffuse Material VectorColorMap.max",
--"\\RPR Diffuse Material VectorMap.max",
--"\\RPR Diffuse Material Waves.max",
--"\\RPR Diffuse Material Wood.max"



    )
    
    count_file = OUT_DIR + "\\expected.json"
    t = (createFile count_file mode:"w")
    line = "[\n"
    format "%" line to:t

    
    for fi=1 to filesToRender.count do (
        assetsFile = res_path + filesToRender[fi]
        loadMaxFile assetsFile quiet:true
        local framesToRender = #(0)
        for fra in framesToRender do (
            if fi!=filesToRender.count do (
                mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\"},\n"
                format "%" mfilename to:t
            ) 
            if fi == filesToRender.count do (
                mfilename = " {\"file_name\": \"" + maxFileName + "_" + (fra as string)  + FILE_EXTENSION +"\"}\n"
                format "%" mfilename to:t
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
        local framesToRender = #(0)

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
                temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n },\n"
                format "%" temp_line to:a
            )
            if fi == filesToRender.count do(
                temp_line = " {\n  \"Test\": \"" + "Feature" + "\",\n  \"Tool\": \"" + ver_max[ver_max.count] +  "\",\n  \"renderDevice\": \""+"CPU"+"\",\n  \"PassLimit\": " + (fr.passLimit as string) + ",\n  \"RenderSize\": " + (RENDER_SIZE as string) + ",\n  \"scene\": \"" + scene_json[scene_json.count] + "\",\n  \"frame\": " + (fra as string) + ",\n  \"Start_Time\": \"" + (localtime as String) + "\",\n  \"file_name\": \"" + mfilename + "\",\n  \"Render_Time\": " + (relapsed as string) + "\n }\n"
                format "%" temp_line to:a
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
