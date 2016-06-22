module.exports = {
    entry: './app.js',
    output: {filename: 'dist.js'},
    devtool: 'source-map',
    module: {
	loaders: [{
            test: /\.jsx?$/, 
            exclude: /node_modules/,
            loader: 'babel' 
	}]
    }
};