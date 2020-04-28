import React, { Component } from "react";

import ReactNative, {
    requireNativeComponent, NativeModules, TouchableOpacity, Text, FlatList,
    UIManager
} from 'react-native';

const RecordComponent = requireNativeComponent('RecordComponent')

export default class ScreenRecorder extends Component {

    constructor(props) {
        super(props);
        this.state = {recordings: []}
    }

    _fetchRecordings = () => {
        NativeModules.SharedFileSystemRCT.getAllFiles()
        .then((recordings) => {
            recordings = recordings.filter(recording => {
                console.log(recording)
                return recording.absolutePath.includes('test_file') && recording.absolutePath.includes('.mp4')
            })            
            this.setState({recordings})
        })
        .catch(console.error)
    }

    componentDidMount() {
        this._fetchRecordings()        
    }

    refreshList = () => {
        this._fetchRecordings()
    }

    viewRecording = (fileName) => {
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(this.recordComponent),
            UIManager.RecordComponent.Commands.showSaveView,
            [fileName]
        );
    }

    render() {
        return <>
            <RecordComponent ref={comp => this.recordComponent = comp} style={{width: 50, height: 50}} />
            {/* <TouchableOpacity onPress={() => this.refreshList()}>
                <Text style={{fontSize: 20}}>{
                    "refresh list"
                }</Text>  
            </TouchableOpacity>   */}
            <FlatList 
                data={this.state.recordings}
                renderItem={(item) => {
                    let fileName = item.item.absolutePath.split("/").splice(-1)[0]
                    return (<TouchableOpacity onPress={() => this.viewRecording(fileName)}>
                        <Text style={{fontSize: 20}}>
                            {fileName}
                        </Text>  
                    </TouchableOpacity>)  
                }}
            />
        </>
    }
}